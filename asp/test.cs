#region DataLayer
    //{"PrimaryValue":"106","PrimaryKey":"TranId","TableNames":{"TableName":"tran","Relation":[{"TableName":"trandetails"},{"TableName":"tranfin"}]}}
    //{"PrimaryValue":"1","PrimaryKey":RoleGroupID,"TableNames":{"TableName":"um.RoleGroupMaster","Relation":[{"TableName":"um.RoleMaster"},{"TableName":" um.UserRoleGroup"}]}}
    class DataLayer
    {
            string connectstring="data source=ADMDEVSQL01;initial catalog=UserManagement;user id=connstring;password=gnirtsnnoc321";
            IDatabase objMsSqlDB;
        public DataLayer()
            {
                objMsSqlDB = new MsSQLDB(connectstring);
            }

            public string getObject(string jsonstr)
            {

                dynamic dyamicobejct = new DynamicJsonObject(jsonstr);
                string PrimaryKey = dyamicobejct["PrimaryKey"];
                string PrimaryValue = dyamicobejct["PrimaryValue"]; ;
                System.Collections.IEnumerable d = dyamicobejct.TableNames;
                DynamicJsonObject objDynamicJsonObject = new DynamicJsonObject();
                ArrayList MasterTable = new ArrayList();
                objDynamicJsonObject = GetObject(PrimaryKey, PrimaryValue, dyamicobejct.TableNames, MasterTable);
                return objDynamicJsonObject.ToString();
            }


            public DynamicJsonObject GetObject(string PrimaryKey, string PrimaryValue, DynamicJsonObject objDynamicJsonObject, ArrayList MasterTable)
            {
                DynamicJsonObject resultDynamicJsonObject = new DynamicJsonObject();
                foreach (System.Collections.Generic.KeyValuePair<string, object> obj in objDynamicJsonObject)
                {


                    if (obj.Value.GetType().IsArray == true)
                    {
                        object t = obj.Value;

                        object[] objdata = (object[])t;
                        for (int i = 0; i < objdata.Length; i++)
                        {
                            DynamicJsonObject obj1 = new DynamicJsonObject();
                            obj1.setObject(objdata[i]);

                            resultDynamicJsonObject = resultDynamicJsonObject + GetObject(PrimaryKey, PrimaryValue, obj1, MasterTable);
                        }
                    }
                    else if (obj.Value.GetType().ToString() == "System.String")
                    {

                        string TableName = obj.Value.ToString();

                        string Query = "Select *  from " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
                       // MsSQLDB objMsSqlDB = new MsSQLDB(connectstring);
                        System.Data.DataTable dt = objMsSqlDB.getQuery(Query);

                        resultDynamicJsonObject.setDataTable(dt, TableName);
                        if(dt.Rows.Count==1)
                            setForeKeyData(resultDynamicJsonObject, TableName, MasterTable);
                        else
                        {
                            System.Collections.ArrayList objes =(  System.Collections.ArrayList) resultDynamicJsonObject[TableName];
                            foreach (dynamic objdata in objes )
                            {
                                setForeKeyData(objdata, TableName, MasterTable);
                            }
                        }
                        MasterTable.Add(TableName);
                    }
                }

            
                return resultDynamicJsonObject;


            }
            public void setForeKeyData(DynamicJsonObject resultDynamicJsonObject, string TableName, ArrayList MasterTable)
        {
            //MsSQLDB objMsSqlDB = new MsSQLDB(connectstring);
              string Query = objMsSqlDB.getForeginkeyQuery(TableName);

          System.Data.DataTable  dt = objMsSqlDB.getQuery(Query);
            foreach (System.Data.DataRow dr in dt.Rows)
            {
                string FkName = dr["FK_ColumnName"].ToString();
                string FkData = resultDynamicJsonObject[FkName].ToString();
                if (FkData != "")
                {
                    
                    Query = "select  *  from  um." + dr["PK_TableName"] + " where  " + dr["PK_ColumnName"] + " =" + FkData;
                    if (!MasterTable.Contains(dr["PK_TableName"].ToString()) )
                    {
                        dt = objMsSqlDB.getQuery(Query);
                        DynamicJsonObject dyamicsubobejct = new DynamicJsonObject();

                        dyamicsubobejct.setDataTable(dt, dr["PK_TableName"].ToString());
                        resultDynamicJsonObject["Virtual" + FkName.Substring(0, FkName.Length - 2)] = dyamicsubobejct;

                        resultDynamicJsonObject.RemoveObject(FkName);
                    }
                }

            }

        }
            public int saveObject(string jsonstr)
            {
                int id = 0;
                try
                {

                    DynamicJsonObject DynamicJsonObject = new DynamicJsonObject(jsonstr);

                  
                    string str = DynamicJsonObject.ToString();

                    foreach (dynamic objDynamicJsonObject in DynamicJsonObject)
                    {


                        DynamicJsonObject MasterKeyValue = new DynamicJsonObject();

                        // MsSQLDB objMsSqlDB = new MsSQLDB(connectstring);
                        dynamic obj = objDynamicJsonObject.Value;
                        DynamicJsonObject TableData = new DynamicJsonObject(obj);
                        string TableName= objDynamicJsonObject.Key.ToString();
                        objMsSqlDB.BeginTran();
                        id = saveRecord(objMsSqlDB, TableName, TableData, MasterKeyValue);
                        objMsSqlDB.Committ();

                    }
                }
                catch(Exception e)
                {

                }
                return id;
            }


            public int saveRecord(IDatabase objMsSqlDB, string TableName, DynamicJsonObject TableData, DynamicJsonObject MasterKeyValue)
        {
            int Id = 0;
            try
            {
                String PrimaryKey = GetPrimaryKey(TableName);
                DynamicJsonObject DetailTable = new DynamicJsonObject();
                

                System.Data.DataTable tableFielddata = objMsSqlDB.GetTable(TableName) ;

                String Query = InsertUpdate(TableName, TableData, MasterKeyValue, DetailTable, tableFielddata);
                
                objMsSqlDB.executeQuery(Query);

                if (TableData._dictionary.Keys.Contains(PrimaryKey))
                    MasterKeyValue[PrimaryKey] = TableData[PrimaryKey];
                else
                    MasterKeyValue[PrimaryKey] = 0;

                if (Convert.ToInt32(MasterKeyValue[PrimaryKey]) == 0)
                {
                  
                    
                     MasterKeyValue[PrimaryKey]=objMsSqlDB.getInsertLastId();

                }
                SaveDetail(objMsSqlDB,DetailTable,MasterKeyValue);

                Id = Convert.ToInt32(MasterKeyValue[PrimaryKey]);
                
            }catch(Exception e)
            {
                objMsSqlDB.RollBack();

            }

             return Id;
        }

        public void  SaveDetail(IDatabase objMsSqlDB,DynamicJsonObject  DetailTables, DynamicJsonObject MasterKeyValue)
	{

            
        
    foreach(dynamic DetailTable   in  DetailTables)
    {
                            if( DetailTable.Value.GetType().IsArray==true)
                            {
                                string TableName = DetailTable.Key.ToString();
                                dynamic obj = DetailTable.Value;
                                DynamicJsonObject TableData = new DynamicJsonObject(obj);
                                int id = saveRecord(objMsSqlDB, TableName, TableData, MasterKeyValue);
                                
                            }
                            else
                            {
                                String  Query=DetailTable.Value;
                                  objMsSqlDB.executeQuery(Query);
                            }
								
    }
        

    }
          public string  GetPrimaryKey(string TableName)
	{
        //$obj=new DyamicClass();
        //$Query=$obj->getPrimaryKey($tableName);
        //$rows=$obj->getQuery($Query);
        //if(count($rows)>0)
        //    return $rows[0]['COLUMN_NAME'];
        //else
        //    return "";
        return TableName+"Id";
	}

          public string InsertUpdate(string TableName, DynamicJsonObject TableData, DynamicJsonObject MasterKeyValue, DynamicJsonObject DetailTable,System.Data.DataTable tableFielddata)
	{
		
        string Query = string.Empty;
        try
        {
            int LoginId = 1;
            string f = "";
            string v = "";
            string fv = "";
            string PrimaryKey = GetPrimaryKey(TableName);
            //string PrimaryKey=$this->GetPrimaryKey($tb);
            int PrimaryKeyValue = 0;
            /*
      foreach( $MasterKeyValue as $insertKey=>$insertValue)
      {
          if( array_search($insertKey,$data))
          {
          unset($data[$insertKey]);
          }
          $f=$insertKey.",";
           $v=$insertValue.",";
      }*/


            foreach (dynamic objdata in TableData)
            {
                dynamic key = objdata.Key;
                dynamic value = objdata.Value;

                if (key == PrimaryKey)
                {
                    PrimaryKeyValue = value;
                }
                else if (isfield(key, tableFielddata))// &&  !$data[substr($key,0,-2)])
                {
                    if (key == "InsertedBy")
                    {
                        f = f + key + ",";
                        v = v + "'" + LoginId + "',";

                    }
                    else if (key == "InsertedDate")
                    {
                        f = f + key + ",";
                        v = v + "'NOW()',";
                    }
                    else if (key == "ModifiedBy")
                    {
                        fv = fv + key + "='" + LoginId + "',";
                    }
                    else if (key == "ModifiedDate")
                    {
                        fv = fv + key + "='NOW()',";
                    }
                    else if (Convert.ToString(value) != String.Empty)
                    {
                        f = f + key + ",";
                        if (value.GetType().ToString() == "Date")
                        {

                            v = v + "'" + value + "',";
                            fv = fv + key + "='" + value + "',";
                        }
                        else
                        {
                            v = v + "'" + value + "',";
                            fv = fv + key + "='" + value + "',";
                        }
                    }
                }
                /*else if($this->isVirtualTable($key))
                {
                    $VirtualTable=substr($key,7);
                    $f=$f.$VirtualTable."Id,";
                    $v=$v."'".$value[$VirtualTable."Id"]."',";
                    $fv=$fv.$VirtualTable."Id='".$value[$VirtualTable."Id"]."',";
                }
                else if(substr($key,-3)=="Ids")
                {
                      if($value!=""  )
                      {
                       $DeleteTable=substr($key,0,-3);
                       $DetailTable[$key]="Delete FROM $DeleteTable WHERE ".$DeleteTable."Id in( ".$value.")";
                      }
                }
                else if($this->isTable($key))
               {
                    if(is_array($value))
                    if(count($value)>0)
                    $DetailTable[$key]=$value;
                }
                  */

            }
            /*
      if (!strpos(f, 'InsertedBy') ) 
      {
          key='InsertedBy';
          if($this->isfield($key,$tb,$tabledata))
          {$f=$f.$key.",";
          $v=$v."'".$LoginId."',";
          }
			
      }
      if (!strpos($f, 'InsertedDate') ) 
      {
          $key='InsertedDate';
          if($this->isfield($key,$tb,$tabledata))
          {$f=$f.$key.",";
          $v=$v."'NOW()',";
          }
      }
      */
            string f1 = f.Substring(0, f.LastIndexOf(','));
            string v1 = v.Substring(0, v.LastIndexOf(','));
            fv = fv.Substring(0, fv.LastIndexOf(','));
            Query = "";
            if (PrimaryKeyValue == 0)
                Query = "INSERT INTO " + TableName + " (" + f1 + ") values (" + v1 + ")";
            else
                Query = "UPDATE " + TableName + " SET " + fv + " where " + PrimaryKey + "= " + PrimaryKeyValue;
        }
              catch(Exception  e)
        {

        }
         
		return Query;
	}
        public bool  isfield(string FieldName,System.Data.DataTable tableFielddata)
	{

        try
        {
            //$datarow=$this->searcharray($key,'COLUMN_NAME',$tabledata);
            System.Data.DataRow[] dr = tableFielddata.Select("column_name='" + FieldName + "'");

            if (dr.Length > 0)
                return true;
            else
            {

                return false;
            }
        }catch(Exception e)
        {

            return false;
        }
	}

        public  bool isVirtualTable(string tableName)
	{
			if(tableName.Trim().Substring (0,7).ToLower()=="virtual")
				return true;
			else
				return false;
	}
    public bool isTable(string TableName)
	{
		string Query="select *  from information_schema.tables where table_Name='$key'";
		
		if( 1==1)
			return true;
		else
			return false;
	}

      /*
       * 
      
	
	
	
	
	
	
	function searcharray($value, $key, $array) {
		 
   foreach ($array as $k => $val) {
	  
       if ($val[$key] == $value) {
           return $val;
       }
   }
   return null;
}
	  function isfield($key,$tb,$tabledata)
	{
		$datarow=$this->searcharray($key,'COLUMN_NAME',$tabledata);
		
		
		if($datarow!=null )
		return true;
		else
		{
			
			return false;
		}
	}
	
	  function isDate($key,$tb,$tabledata)
	{
		$datarow=$this->searcharray($key,'COLUMN_NAME',$tabledata);
		if($datarow['Data_Type']=='Date' )
		return true;
		else
		{
			
			return false;
		}
	}
	
	
        public string deleteObject(string jsonstr)
        {
            return string.Empty;
        }
        public string List(string TableName,String Query)
        {
            MsSQLDB objMsSqlDB = new MsSQLDB(connectstring);
            System.Data.DataTable dt = objMsSqlDB.getQuery(Query);
            DynamicJsonObject objDynamicJsonObject = new DynamicJsonObject();
            objDynamicJsonObject.setDataTable(dt, TableName);

            return objDynamicJsonObject.ToString();
        }
        public string Query(string jsonstr)
        {
            return string.Empty;

        }
       */ 

    }
    public interface IDatabase
    {

         System.Data.DataTable getQuery(string Query);
         string getForeginkeyQuery(String TableName);
          void BeginTran();
         void Committ();
          void RollBack();
      void   executeQuery(string Query);
           int executeReader(string Query);
           System.Data.DataTable GetTable(string TableName);
          int getInsertLastId();
         
    }
    public class MsSQLDB : IDatabase
    {
         string _connectionstr;
        
        string DBName = "UserManagement";
        string Schema = "UM";
        
        System.Data.SqlClient.SqlTransaction transaction;
        System.Data.SqlClient.SqlConnection objSqlConnection;

        public MsSQLDB(string connectionstr)
        {
            _connectionstr = connectionstr;
          

        }
        public  System.Data.DataTable GetTable(String TableName)
        {
            string Query = "select *  from information_schema.COLUMNS  where table_name='" + TableName + "' ";
            return  getQuery(Query);

        }

        public System.Data.DataTable getQuery(string Query)
        {

            System.Data.SqlClient.SqlConnection objSqlConnection = new System.Data.SqlClient.SqlConnection(_connectionstr);

            System.Data.SqlClient.SqlDataAdapter ad = new System.Data.SqlClient.SqlDataAdapter(Query, objSqlConnection);
            System.Data.DataTable dt = new System.Data.DataTable();
            ad.Fill(dt);

            return dt;

        }
        public string getForeginkeyQuery(String TableName)
        {
            string Query = "SELECT  COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='" + TableName + "'  and  table_schema='" + Schema + "' and REFERENCED_COLUMN_NAME is not null";
            Query = "SELECT ao.name AS PK_TableName, c.name AS  PK_ColumnName,pc.name AS FK_ColumnName, *  FROM sys.foreign_key_columns fkc INNER JOIN sys.all_objects ao on fkc.referenced_object_id=ao.object_id INNER JOIN sys.columns c ON ao.object_id = c.object_id AND c.column_id=fkc.constraint_column_id INNER JOIN sys.columns pc ON fkc.parent_object_id = pc.object_id AND pc.column_id=fkc.parent_column_id WHERE fkc.parent_object_id=OBJECT_ID('"+TableName+"')";
            return Query;
        }
        public void BeginTran()
        {
           objSqlConnection  = new System.Data.SqlClient.SqlConnection(_connectionstr);
            objSqlConnection.Open();
            transaction = objSqlConnection.BeginTransaction("SampleTransaction");
        }

        public int getInsertLastId()
        {
              string Query = "select SCOPE_IDENTITY() ";
            return  executeReader(Query);

        }

        public void Committ()
        {
            
            transaction.Commit();
            objSqlConnection.Close();

        }

        public void RollBack()
        {

            transaction.Rollback();
            objSqlConnection.Close();
        }

        public void executeQuery(string Query)
        {
            System.Data.SqlClient.SqlCommand command = objSqlConnection.CreateCommand();
            command.Transaction = transaction;
            command.CommandText = Query;
            command.ExecuteNonQuery();

        }

        public int executeReader(string Query)
        {

            int Id=0;
            System.Data.SqlClient.SqlCommand command = objSqlConnection.CreateCommand();
            command.Transaction = transaction;
            command.CommandText = Query;
            
             System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();

            // Call Read before accessing data.
            if (reader.Read())
            {
                
                Id = Convert.ToInt32(reader[0]);
            }
            reader.Close();


            return Id;
        }
        
    }
   
    public class MySqlDB : IDatabase
    {

        string _connectionstr;
        MySqlConnection objSqlConnection;
        string Schema = "Account";
        public MySqlDB(string connectionstr)
        {
            _connectionstr = connectionstr;
            objSqlConnection = new MySqlConnection(_connectionstr);

        }
        public  System.Data.DataTable GetTable(String TableName)
        {
            string Query = "select *  from information_schema.COLUMNS  where table_name='" + TableName + "' ";
            return  getQuery(Query);

        }
        public System.Data.DataTable getQuery(string Query)
        {



            MySqlDataAdapter ad = new MySqlDataAdapter(Query, objSqlConnection);
            System.Data.DataTable dt = new System.Data.DataTable();
            ad.Fill(dt);

            return dt;

        }
        public string getForeginkeyQuery(String TableName)
        {
            string Query = "SELECT  COLUMN_NAME AS FK_ColumnName,REFERENCED_TABLE_NAME AS  PK_TableName,REFERENCED_COLUMN_NAME  AS  PK_ColumnName  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='" + TableName + "'  and  table_schema='" + Schema + "' and REFERENCED_COLUMN_NAME is not null";
            return Query;
        }
        public void BeginTran()
        {

        }

        public void Committ()
        {

        }

        public void RollBack()
        {

        }

        public void executeQuery(string Query)
        {

        }
            public int getInsertLastId()
        {
              
     string Query = "SELECT  LAST_INSERT_ID()";
            return  executeReader(Query);

        }
        public int executeReader(string Query)
        {

            int Id=0;
            //System.Data.SqlClient.SqlCommand command = new System.Data.SqlClient.SqlCommand();
            //command.Transaction = transaction;
            //command.CommandText = Query;
            
            // System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();

            //// Call Read before accessing data.
            //while (reader.Read())
            //{
            //       Id= Convert.ToInt32( reader);
            //}
            //reader.Close();


            return Id;
        }
		
    }
    [Serializable]
    public sealed class DynamicJsonObject : System.Dynamic.DynamicObject, IEnumerable
    
    {
        public readonly IDictionary<string, object> _dictionary;
        public int count = 0;
        public DynamicJsonObject(IDictionary<string, object> dictionary)
        {
            if (dictionary == null)
                throw new ArgumentNullException("dictionary");
            _dictionary = dictionary;
            count = _dictionary.Count;
        }
        public void setObject(object obj)
        {

           
                System.Collections.Generic.Dictionary<string, object> keydata2 = (System.Collections.Generic.Dictionary<string, object>)obj;

                System.Collections.Generic.KeyValuePair<string, object> keydata = keydata2.First();
                _dictionary.Add(keydata.Key, keydata.Value);

            
            //count = _dictionary.Count;
        }
        public static DynamicJsonObject operator +(DynamicJsonObject First, DynamicJsonObject Secoend)
        {
            System.Collections.Generic.IDictionary<string, object> keydata = Secoend._dictionary;


            if (keydata.Count > 0)
                ((dynamic)First)[keydata.First().Key] = keydata.First().Value;
            return First;
        }
        public DynamicJsonObject(System.Collections.Generic.KeyValuePair<string, object> dictionary)
        {
            _dictionary = new Dictionary<string, object>();
            _dictionary.Add(dictionary.Key, dictionary.Value);
            // _dictionary = dictionary;
            count = _dictionary.Count;
        } 
        public DynamicJsonObject(System.Collections.Generic.KeyValuePair<string, object>  []dictionary)
        {
            foreach (var item in dictionary)
                _dictionary.Add(item.Key, item.Value);
           // _dictionary = dictionary;
            count = _dictionary.Count;
        }
        IEnumerator IEnumerable.GetEnumerator()
        {
            return _dictionary.GetEnumerator();
        }
        public DynamicJsonObject()
        {
            _dictionary = new Dictionary<string, object>();
        }
        // public static void RemoveMember(object dynamicObject, string memberName);
        //public static bool TryRemoveMember(object dynamicObject, string memberName, out object removedMember);
        public DynamicJsonObject(string strjson)
        {
            _dictionary = jsonToObject(strjson);
        }

        public dynamic jsonToObject(string strjson)
        {
            
            System.Web.Script.Serialization.JavaScriptSerializer j = new System.Web.Script.Serialization.JavaScriptSerializer();
            dynamic objectdata = j.Deserialize(strjson, typeof(object));

            dynamic result = new Dictionary<string, object>();
            foreach (dynamic obj in objectdata)
            {


                dynamic dictionary = obj.Value as IDictionary<string, object>;
                if (dictionary == null)
                    result.Add(obj.Key, obj.Value);
                else
                {
                    dynamic objectData = dynamicobject(dictionary);
                    result.Add(obj.Key, objectData);
                }

            }
            // result = dynamicobject(objectdata);
            return result;


        }


        public dynamic dynamicobject(dynamic objectdata)
        {
            Dictionary<string, object> result = new Dictionary<string, object>();
            foreach (dynamic obj in objectdata)
            {

                dynamic dictionary = obj.Value as IDictionary<string, object>;
                if (dictionary == null)
                    result.Add(obj.Key, obj.Value);
                else
                {
                    dynamic objectData = dynamicobject(obj.Value);
                    result.Add(obj.Key, objectData);
                }




            }
            return result;

        }

        public void RemoveObject(string columnName)
        {

            _dictionary.Remove(columnName);
        }
        public object this[string name]
        {
           
            get   
        {  
            // use indexto retrieve and return another value.    
            return _dictionary[name];
        }  
        set   
        {  
            // use index and value to set the value somewhere.   
            _dictionary[name] = value;
        } 
        }
        public override string ToString()
        {
            var sb = new System.Text.StringBuilder("{");
            ToString(sb);
            return sb.ToString();
        }
        public void setDataTable(System.Data.DataTable dt,string tableName)
        {
            System.Collections.ArrayList arrayList = new System.Collections.ArrayList();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dynamic objDynamicJsonObject = new DynamicJsonObject();
                
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (dt.Rows[i][j].GetType() == typeof(DateTime))
                    {

                        if (dt.Rows.Count == 1)
                        _dictionary.Add(dt.Columns[j].ColumnName, Convert.ToDateTime(dt.Rows[i][j]).ToString("dd-MMM-yyyy"));
                        else
                        objDynamicJsonObject[dt.Columns[j].ColumnName] = Convert.ToDateTime(dt.Rows[i][j]).ToString("dd-MMM-yyyy");
                    }
                    else
                    {
                        if (dt.Rows.Count == 1)
                        _dictionary.Add(dt.Columns[j].ColumnName, dt.Rows[i][j].ToString());
                        else
                        objDynamicJsonObject[dt.Columns[j].ColumnName] = dt.Rows[i][j].ToString();
                    }
                }
                arrayList.Add(objDynamicJsonObject);

            }
            if (dt.Rows.Count == 1)
            {
                //_dictionary = ((DynamicJsonObject)arrayList[0])._dictionary;
            }
            else if (dt.Rows.Count>1)
            {
                _dictionary[tableName] = arrayList;
            }


        }

        private void ToString(System.Text.StringBuilder sb)
        {
            var firstInDictionary = true;
            foreach (var pair in _dictionary)
            {
                if (!firstInDictionary)
                    sb.Append(",");
                firstInDictionary = false;
                var value = pair.Value;
                var name = pair.Key;
                if (value is string)
                {
                    //sb.AppendFormat("{0}:\"{1}\"", name, value);

                    sb.AppendFormat("\"{0}\":\"{1}\"", name, value);
                }
                else if (value is DateTime)
                {
                    sb.AppendFormat("\"{0}\":\"{1}\"", name, value);
                }
                else if (value is IDictionary<string, object>)
                {
                    sb.Append("\"" + name + "\":");
                    new DynamicJsonObject((IDictionary<string, object>)value).ToString(sb.Append("{"));

                    //var objCollection = value as IDictionary<string, object>;
                    //sb.Append("\"" + name + "\":[");
                    //var firstInArray = true;
                    //foreach (var objectField in objCollection)
                    //{

                    //    if (!firstInArray)
                    //        sb.Append(",");
                    //    firstInArray = false;

                    //    new DynamicJsonObject(objectField).ToString(sb.Append("{"));
                    //}
                    //sb.Append("]");
                }
                else if (value is System.Collections.Generic.List<object>)
                {
                    var objCollection = value as System.Collections.Generic.List<object>;
                    sb.Append("\"" + name + "\":[");
                    var firstInArray = true;
                    foreach (var objectField in objCollection)
                    {

                        if (!firstInArray)
                            sb.Append(",");
                        firstInArray = false;
                        new DynamicJsonObject((IDictionary<string, object>)((DynamicJsonObject)(objectField))._dictionary).ToString(sb.Append("{"));
                    }
                    sb.Append("]");
                }
                else if (value is System.Collections.ArrayList)
                {
                    sb.Append("\"" + name + "\":[");
                    var firstInArray = true;
                    foreach (var arrayValue in (System.Collections.ArrayList)value)
                    {
                        if (!firstInArray)
                            sb.Append(",");
                        firstInArray = false;
                        if (arrayValue is IDictionary<string, object>)
                            new DynamicJsonObject((IDictionary<string, object>)arrayValue).ToString(sb.Append("{"));
                        else if (arrayValue is string)
                            sb.AppendFormat("\"{0}\"", arrayValue);
                        else
                            sb.AppendFormat("{0}", arrayValue);

                    }
                    sb.Append("]");
                }
                else if (value is DBNull)
                {
                    sb.AppendFormat("\"{0}\":\"\"", name);
                    //sb.AppendFormat("\"{0}\":0", name);
                }
                else if (value.GetType().IsArray ==true )
                {
                   // sb.AppendFormat("\"{0}\":\"\"", name);
                    //sb.AppendFormat("\"{0}\":0", name);
                    object  [] objCollection = (object[])value ;
                    sb.Append("\"" + name + "\":[");
                    var firstInArray = true;
                    foreach (var objectField in objCollection)
                    {

                        if (!firstInArray)
                            sb.Append(",");
                        firstInArray = false;

                        new DynamicJsonObject(objectField as IDictionary<string, object>).ToString(sb.Append("{"));
                    }
                    sb.Append("]");
                }    
                else
                {
                    sb.AppendFormat("\"{0}\":{1}", name, value);
                }
            }
            sb.Append("}");
        }


        public override bool TryGetMember(System.Dynamic.GetMemberBinder binder, out object result)
        {
            if (!_dictionary.TryGetValue(binder.Name, out result))
            {
                // return null to avoid exception.  caller can check for null this way...
                result = null;
                return true;
            }

            result = WrapResultObject(result);
            return true;
        }



        public override bool TrySetMember(System.Dynamic.SetMemberBinder binder, object result)
        {


            // _dictionary.Remove(binder.Name);
            // _dictionary.Add(binder.Name, result);
            // base.TrySetMember(binder, result);
            _dictionary[binder.Name] = result;
            return true;
        }




        public override bool TrySetIndex(System.Dynamic.SetIndexBinder binder, object[] indexes, object result)
        {

            if (indexes.Length == 1 && indexes[0] != null)
            {
                if (indexes.Length > 0)
                {
                    string key = indexes[0].ToString();
                    _dictionary[key] = result;
                    //_dictionary.Remove(key);
                    //_dictionary.Add(key, result);
                    result = null;
                    return true;
                }


                return true;
            }

            return base.TrySetIndex(binder, indexes, result);
        }
        public override bool TryGetIndex(System.Dynamic.GetIndexBinder binder, object[] indexes, out object result)
        {
            if (indexes.Length == 1 && indexes[0] != null)
            {
                if (!_dictionary.TryGetValue(indexes[0].ToString(), out result))
                {
                    // return null to avoid exception.  caller can check for null this way...
                    result = null;
                    return true;
                }

                result = WrapResultObject(result);
                return true;
            }

            return base.TryGetIndex(binder, indexes, out result);
        }

        private static object WrapResultObject(object result)
        {
            var dictionary = result as IDictionary<string, object>;
            if (dictionary != null)
                return new DynamicJsonObject(dictionary);

            var arrayList = result as System.Collections.ArrayList;
            if (arrayList != null && arrayList.Count > 0)
            {
                return arrayList[0] is IDictionary<string, object>
                    ? new List<object>(arrayList.Cast<IDictionary<string, object>>().Select(x => new DynamicJsonObject(x)))
                    : new List<object>(arrayList.Cast<object>());
            }

            return result;
        }
    }
    public class MySqlConnection
    {
        public MySqlConnection()
        {

        }
        public MySqlConnection(string connection)
        {

        }
    }
    public class MySqlDataAdapter
    {
        public MySqlDataAdapter(string Query, MySqlConnection objSqlConnection)
        {

        }
        public void Fill(System.Data.DataTable dt)
        {

        }
    }
#endregion
