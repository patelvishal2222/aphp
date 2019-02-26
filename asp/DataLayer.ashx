<%@ WebHandler Language="C#" CodeBehind="DataLayer.ashx" Class="DataLayer" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using  System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using System.ComponentModel.DataAnnotations;
using MySql.Data.MySqlClient;
using System.Dynamic;
using System.Text;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;


using System.Web.Script.Serialization;
public class DataLayer:IHttpHandler
{

string connectionstring="Data Source=ADV-WKS-IN-0285\\TEST;Initial Catalog=Account;Persist Security Info=True;User ID=sa;password=Rinal@2018";
string mysqlconnectionString="Server=localhost;userid=root;password=root;Database=Account;Convert Zero Datetime=True"  ;
    public bool IsReusable
    {
        get { return false; }
    }
  
    public void ProcessRequest(HttpContext context)
    {
     	
		HttpRequest Request = context.Request;
            HttpResponse Response = context.Response;
             if(Request.HttpMethod=="POST")
			 {
				  Response.Write( context.Request.Params);
			 }
       
		  else if(context.Request.QueryString["Query"]!=null)
            {
			  
				String Query=context.Request.QueryString["Query"];
				 MasterDB objMsSqlDB=new MasterDB(DatabaseType.MS_SQL,mysqlconnectionString);
				 DataTable dt=objMsSqlDB.getQuery(Query);
				 string  webdata =DabaseManager.DataTableTOJson(dt);
				  Response.Write(webdata);
          
			}
			else  if(context.Request.QueryString["getObject"]!=null)
			{
			String strgetObject=context.Request.QueryString["getObject"].Trim();
			MasterDB objMsSqlDB=new MasterDB(DatabaseType.MS_SQL,mysqlconnectionString);
			DBLayer objDataLayer=new DBLayer(objMsSqlDB);
			Response.Write(objDataLayer.getObject(strgetObject));
			return ;
			
				
			}
			else  if(context.Request.QueryString["List"]!=null)
			{
			String TableName=context.Request.QueryString["List"];
				String  Query=context.Request.QueryString["Sql"];
				 MasterDB objMsSqlDB=new MasterDB(DatabaseType.MS_SQL,mysqlconnectionString);
				 DataTable dt=objMsSqlDB.getQuery(Query);
				 string  webdata =DabaseManager.DataTableTOJson(dt);
				  Response.Write(webdata);
			}
			else  if(context.Request.QueryString["deleteObject"]!=null)
			{
			}
			
			else  if(context.Request.QueryString["saveObject"]!=null)
			{
				String strgetObject=context.Request.QueryString["saveObject"].Trim();
			MasterDB objMsSqlDB=new MasterDB(DatabaseType.MS_SQL,mysqlconnectionString);
			DBLayer objDataLayer=new DBLayer(objMsSqlDB);
			objDataLayer.saveObject(strgetObject);
			}
			else  if(context.Request.QueryString["getObject2"]!=null)
			{
			
			
			string TableName=context.Request.QueryString["getObject2"].Trim();
			String PrimaryKey=context.Request.QueryString["PrimaryKey"];
			String PrimaryValue=context.Request.QueryString["PrimaryValue"];
			String Query="Select *  FROM "+TableName+" WHERE "+PrimaryKey+"="+PrimaryValue;
			MasterDB objMsSqlDB=new MasterDB(DatabaseType.MS_SQL,mysqlconnectionString);
    	    DataTable dt=objMsSqlDB.getQuery(Query);
			dynamic  dyamicobejct=new  DynamicJsonObject();
			dyamicobejct.setDataTable(dt);
			   Query =objMsSqlDB.getForeginkeyQuery(TableName);
			   dt=objMsSqlDB.getQuery(Query);
				foreach(DataRow  dr in dt.Rows)
				{
				  String  FkName=dr["FK_ColumnName"].ToString();
				  string FkData=dyamicobejct[FkName];
				  if(FkData!="")
				  {
				  Query="select  *  from   "+ dr["PK_TableName"] +" where  "+dr["PK_ColumnName"]+" ="+FkData  ;
				     dt=objMsSqlDB.getQuery(Query);
					 dynamic  dyamicsubobejct=new  DynamicJsonObject();
					 dyamicsubobejct.setDataTable(dt);
					dyamicobejct["Virtual"+FkName.Substring(0,FkName.Length-2)]=dyamicsubobejct;
				  	dyamicobejct.RemoveObject(FkName);
					}
				}
				  Response.Write(dyamicobejct.ToString());
			}
			else
			{context.Response.Write("ERROR");
			}
			
			
        
    }
	
	

}
  public class DabaseManager
    {
	
	public static string DataTableTOJson(DataTable dt)
	{
	
	
	 
				String webdata = string.Empty;
            webdata = webdata + "{\"listdata\":[";
				
                  
                foreach(DataRow  dr in dt.Rows)
                {



                    webdata = webdata + "{";
                    foreach( DataColumn  dc in dt.Columns )
                    {

                        if(dr[dc.ColumnName].GetType()==  typeof(DateTime) )
                        {
                            webdata = webdata + "\"" + dc.ColumnName + "\":\"" + Convert.ToDateTime(dr[dc.ColumnName]).ToString("dd-MMM-yyyy") + "\",";
                        }
                        else

                        webdata = webdata + "\"" + dc.ColumnName + "\":\"" + dr[dc.ColumnName].ToString().Replace(";", "").Replace("\"", "" )+ "\",";
                        
                    }
                    webdata = Removelastcomm(webdata);
                    webdata = webdata + "},";
                    
                }
                
             webdata = Removelastcomm(webdata);
           webdata = webdata + "]}";
		   
		   return webdata;
	}
	
	public static string Removelastcomm(string data)
            {
                if (data.LastIndexOf(',') >=0)
                {
                    data = data.Substring(0, data.LastIndexOf(','));
                }
            return data;
        }

    }
 public class NotSqlEffect : Attribute
    {

    }
public	enum  DatabaseType
	{
		SQL_SERVER=1,
		MS_SQL=2,
	}
public class  MasterDB
{
	
	IDatabase dbObject;
			public	MasterDB( DatabaseType databaseType,string connectionstr)	
				{
					
					if(databaseType==DatabaseType.SQL_SERVER)
					dbObject=new MsSqlDB(connectionstr);
					else if(databaseType==DatabaseType.MS_SQL)
					dbObject=new MySqlDB(connectionstr);
						
					
				}
				public DataTable getQuery(string Query)
				{
					return dbObject.getQuery(Query);
				}
				 public string getForeginkeyQuery(String TableName)
				 {
					 return dbObject.getForeginkeyQuery(TableName);
				 }		

			public  void			 BeginTran()
			{
				dbObject.BeginTran();
			}
	 public  void			 RollBack()
			{
				dbObject.RollBack();
			}
			 public  void			 Committ()
			{
				dbObject.Committ();
			}
			public System.Data.DataTable GetTable(string TableName)
			{
				return dbObject.GetTable(TableName);
			}
			 public  void			 executeQuery(string Query)
			{
				dbObject.executeQuery(Query);
			}
			 public int getInsertLastId()
			 
			 {
				 return dbObject.getInsertLastId();
				 
			 }

}
public interface  IDatabase 
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
public class  MsSqlDB : IDatabase
{

 string _connectionstr;
        SqlConnection objSqlConnection;
		
        
        string DBName = "UserManagement";
        string Schema = "UM";
        
        System.Data.SqlClient.SqlTransaction transaction;
      

        public MsSqlDB(string connectionstr)
        {
            _connectionstr = connectionstr;
            objSqlConnection = new SqlConnection(_connectionstr);

        }
        public DataTable getQuery(string Query)
        {
            SqlDataAdapter ad=new SqlDataAdapter(Query,objSqlConnection);
                DataTable dt=new DataTable();
                ad.Fill(dt) ;

            return dt;

        }
public string getForeginkeyQuery(String TableName)
		{
		string  Query="SELECT  COLUMN_NAME AS FK_ColumnName,REFERENCED_TABLE_NAME AS  PK_TableName,REFERENCED_COLUMN_NAME  AS  PK_ColumnName  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='"+TableName+"'  and  table_schema='"+"' and REFERENCED_COLUMN_NAME is not null";
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
public  System.Data.DataTable GetTable(String TableName)
        {
            string Query = "select *  from information_schema.COLUMNS  where table_name='" + TableName + "' ";
            return  getQuery(Query);

}
/*
        public string InsertUpdateQuery<T>(string tableName,T obj)
        {
            string sql = string.Empty;
            string InsertSql = string.Empty;
            string UpdateSql = string.Empty;
            string InsertField = string.Empty;
            string InsertValue = string.Empty;
            string UpdateFieldValue = string.Empty;
            string TableName = string.Empty;
            string KeyName = string.Empty;
            int KeyValue = 0;
            bool NoQuery = false;
            Type TypeObject = typeof(T);
            TableName = TypeObject.Name;
            TableName = tableName;

            foreach (PropertyInfo pro in TypeObject.GetProperties())
            {
                if (pro.GetGetMethod().IsVirtual == true)
                {

                }
                else if (pro.GetCustomAttributes().Count() > 0)
                {
                    NoQuery = false;
                    foreach (Attribute Attribute in pro.GetCustomAttributes())
                    {
                        if (Attribute is KeyAttribute)
                        {
                            KeyName = pro.Name;
                            KeyValue = Convert.ToInt32(pro.GetValue(obj).ToString());
                            NoQuery = true;
                        }
                        else if (Attribute is NotSqlEffect)
                        {
                            NoQuery = true;
                        }


                    }

                    if (NoQuery == false)
                    {

                        DataTypeQuery<T>(pro, obj, ref InsertField, ref InsertValue, ref UpdateFieldValue);
                    }
                }
                else
                {

                    DataTypeQuery<T>(pro, obj, ref InsertField, ref InsertValue, ref UpdateFieldValue);



                }
            }
            InsertField = RemoveLastComm(InsertField);
            InsertValue = RemoveLastComm(InsertValue);
            UpdateFieldValue = RemoveLastComm(UpdateFieldValue);
            InsertSql = "Insert Into " + TableName + "(" + InsertField + ")values(" + InsertValue + ")";
            UpdateSql = "Update " + TableName + " Set " + UpdateFieldValue + " WHERE " + KeyName + "=" + KeyValue.ToString();

            if (KeyValue == 0)
            {
                sql = InsertSql;
            }
            else
            {
                sql = UpdateSql;
            }

            return sql;

        }
        public void DataTypeQuery<T>(PropertyInfo pro, T obj, ref  string InsertField, ref string InsertValue, ref string UpdateFieldValue)
        {
            InsertField = InsertField + pro.Name + ",";
            if (pro.PropertyType == typeof(string))
            {

                InsertValue = InsertValue + "'" + pro.GetValue(obj) + "',";
                UpdateFieldValue = UpdateFieldValue + pro.Name + "='" + pro.GetValue(obj) + "',";
            }
            else if (pro.PropertyType == typeof(Int32) || pro.PropertyType == typeof(System.Decimal))
            {
                InsertValue = InsertValue + "" + pro.GetValue(obj) + ",";
                UpdateFieldValue = UpdateFieldValue + pro.Name + "=" + pro.GetValue(obj) + ",";


            }
            else if (pro.PropertyType == typeof(bool))
            {
                InsertValue = InsertValue + "" + (Convert.ToBoolean(pro.GetValue(obj)) == true ? 1 : 0) + ",";
                UpdateFieldValue = UpdateFieldValue + pro.Name + "=" + (Convert.ToBoolean(pro.GetValue(obj)) == true ? 1 : 0) + ",";

            }
            else
            {
                InsertValue = InsertValue + "'" + pro.GetValue(obj) + "',";
                UpdateFieldValue = UpdateFieldValue + pro.Name + "='" + pro.GetValue(obj) + "',";
            }
        }

        public string RemoveLastComm(string str)
        {
            if (str.LastIndexOf(",") > 0)
            {
                str = str.Substring(0, str.LastIndexOf(","));

            }
            return str;
        }
        public void save(string Query)
        {
            SqlCommand cmd = new SqlCommand();
           
            try
            {
                
                objSqlConnection.Open();
                cmd.Connection = objSqlConnection;
                cmd.CommandText = Query;
                cmd.CommandType = CommandType.Text;
               
                cmd.ExecuteNonQuery();
            }
            catch
            {

            }
            finally
            {
                objSqlConnection.Close();

            }
            
            

        }

        public SqlDataReader Get(string Query)
        {
            SqlCommand cmd = new SqlCommand();
            SqlDataReader rd; ;

            try
            {

                objSqlConnection.Open();
                cmd.Connection = objSqlConnection;
                cmd.CommandText = Query;
                cmd.CommandType = CommandType.Text;

                rd = cmd.ExecuteReader();
            }
            catch
            {

            }
            finally
            {
                objSqlConnection.Close();

            }

            return null;


        }*/

}
public class  MySqlDB : IDatabase
{
string _connectionstr;
        MySqlConnection objSqlConnection;
		string Schema="Account";
        public MySqlDB(string connectionstr)
        {
            _connectionstr = connectionstr;
            objSqlConnection = new MySqlConnection(_connectionstr);

        }
        public DataTable getQuery(string Query)
        {
            

			
            MySqlDataAdapter  ad=new MySqlDataAdapter (Query,objSqlConnection);
                DataTable dt=new DataTable();
                ad.Fill(dt) ;

            return dt;

        }
		public string getForeginkeyQuery(String TableName)
		{
		string  Query="SELECT  COLUMN_NAME AS FK_ColumnName,REFERENCED_TABLE_NAME AS  PK_TableName,REFERENCED_COLUMN_NAME  AS  PK_ColumnName  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='"+TableName+"'  and  table_schema='"+Schema+"' and REFERENCED_COLUMN_NAME is not null";
		return Query;
		}
		
		
		public  System.Data.DataTable GetTable(String TableName)
        {
            string Query = "select *  from information_schema.COLUMNS  where table_name='" + TableName + "' ";
            return  getQuery(Query);

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



 #region Nested type: DynamicJsonObject
    [Serializable]
    public sealed class DynamicJsonObject : System.Dynamic.DynamicObject, IEnumerable
    {
        public readonly IDictionary<string, object> _dictionary;
        public int count=0;
        public DynamicJsonObject(IDictionary<string, object> dictionary)
        {
            if (dictionary == null)
                throw new ArgumentNullException("dictionary");
            _dictionary = dictionary;
            count = _dictionary.Count; 
        }
        public DynamicJsonObject()
        {
            _dictionary = new Dictionary<string, object>();
        }
		
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

		
		 public void setObject(object obj)
        {

           
                System.Collections.Generic.Dictionary<string, object> keydata2 = (System.Collections.Generic.Dictionary<string, object>)obj;

                System.Collections.Generic.KeyValuePair<string, object> keydata = keydata2.First();
                _dictionary.Add(keydata.Key, keydata.Value);

            
            //count = _dictionary.Count;
        }
        public static DynamicJsonObject operator +(DynamicJsonObject First, DynamicJsonObject Secoend)
        {
			if(Secoend==null  || First==null )
			{
			}
			else
			{
            System.Collections.Generic.IDictionary<string, object> keydata = Secoend._dictionary;

			
			if(keydata.Count>0)
            
			 ((dynamic)First)[keydata.First().Key] = keydata.First().Value;
			}
            return First;
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
		public bool isJsonObject(string jsonStr)
		{
			if(jsonStr.Substring(0,1)=="{"  &&  jsonStr.Substring(jsonStr.Length-1,1)=="}")
				{
						return true;
				}
				else
					return false;
			
			
		}
		public bool isJsonArray(string jsonStr)
		{
			if(jsonStr.Substring(0,1)=="["  &&  jsonStr.Substring(jsonStr.Length-1,1)=="]")
				{
						return true;
				}
				else
					return false;
			
			
		}
		
		public bool isJsonField(string jsonStr)
		{
			string []strObject=jsonStr.Split(':');
				if(strObject.Length>0)
				{
						return true;
				}
				else
					return false;
			
			
		}
		public Dictionary<string, object>  jsonObject(string jsonStr )
		{
		
			Dictionary<string, object> _dictionary = new Dictionary<string, object>();
			
		if(isJsonObject(jsonStr))
		{
			
			jsonStr=removeBracket(jsonStr,"{","}"); 
			_dictionary["object"]=jsonStr;
			  _dictionary =jsonObject(jsonStr);
		}
		else if(isJsonArray(jsonStr))
		{
			_dictionary["arrya"]=jsonStr;
		}
		else if(isJsonField(jsonStr))
		{
		
		
	
		
			foreach(string strdata in jsonStr.Split(','))
			{
				string []strObject=strdata.Split(':');
				if(strObject.Length==2)
				{
				  strObject[0]=removeBracket(strObject[0]);
				  strObject[1]=removeBracket(strObject[1]);
			 _dictionary[strObject[0]]=strObject[1];
				}
			  else 
				{
				 // strObject[0]=removeBracket(strObject[0]);
				 // strObject[1]=removeBracket(strObject[1]);
				  // _dictionary[ strObject[0]]=strObject[1];
				}
			}
			
		}
		else
		{
			//_dictionary["data"]=jsonStr;
		}
		return _dictionary;
		}
		
		
		public IEnumerable<int>  getObjectSplit(string jsonStr)
		
		{
			
			for (int i=0;i<jsonStr.Length;i++)
			{
				 if(jsonStr[i]==',')
				 {
					 yield return i;
				 }
			}
		}
		public string removeBracket(string jsonStr,string startStr="\"",string endStr="\"")
		{
			jsonStr=jsonStr.Trim();
			if(jsonStr.Substring(0,1)==startStr);
				{
					jsonStr= jsonStr.Substring(1);
				}
			if(jsonStr.Substring(jsonStr.Length-1,1)==endStr);
				{
					jsonStr= jsonStr.Substring(0,jsonStr.Length-1);
				}	
				return jsonStr;
		}
		// public static void RemoveMember(object dynamicObject, string memberName);
  //public static bool TryRemoveMember(object dynamicObject, string memberName, out object removedMember);
		
		public  void RemoveObject(string columnName)
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
            var sb = new StringBuilder("{");
            ToString(sb);
            return sb.ToString();
        }
		public void setDataTable(DataTable dt)
		{
		ArrayList arrayList=new ArrayList();
		
		 for(int i=0;i<dt.Rows.Count;i++)
				{
					dynamic objDynamicJsonObject=new DynamicJsonObject();
					for( int j=0;j<dt.Columns.Count;j++)
					{
						if(dt.Rows[i][j].GetType()==  typeof(DateTime) )
                        {
                          _dictionary.Add(dt.Columns[j].ColumnName, Convert.ToDateTime(dt.Rows[i][j]).ToString("dd-MMM-yyyy"));
						  objDynamicJsonObject[dt.Columns[j].ColumnName]= Convert.ToDateTime(dt.Rows[i][j]).ToString("dd-MMM-yyyy");
                        }
                        else
						{
							 _dictionary.Add(dt.Columns[j].ColumnName,dt.Rows[i][j].ToString());
							 objDynamicJsonObject[dt.Columns[j].ColumnName]= dt.Rows[i][j].ToString();
						}
					}
					arrayList.Add(objDynamicJsonObject);
				
				}
				 
				
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

        private void ToString(StringBuilder sb)
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
                }
                else if( value is System.Collections.Generic.List<object > )
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
                else if (value is ArrayList)
                {
                    sb.Append("\"" + name + "\":[");
                    var firstInArray = true;
                    foreach (var arrayValue in (ArrayList)value)
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
                else if (value is DBNull)
                {
                    sb.AppendFormat("\"{0}\":\"\"", name);
                    //sb.AppendFormat("\"{0}\":0", name);
                }
                else

                {
                    sb.AppendFormat("\"{0}\":{1}", name, value);
                }
            }
            sb.Append("}");
        }

        public override bool TryGetMember(GetMemberBinder binder, out object result)
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
       
        

        public override bool TrySetMember(SetMemberBinder binder, object result)
        {

           
           // _dictionary.Remove(binder.Name);
           // _dictionary.Add(binder.Name, result);
           // base.TrySetMember(binder, result);
            _dictionary[binder.Name] = result;
            return true;
        }


     
        
        public override bool TrySetIndex(SetIndexBinder binder, object[] indexes, object result)
        {

            if (indexes.Length == 1 && indexes[0] != null)
            {
               if (indexes.Length >0)
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

            return base.TrySetIndex(binder, indexes,  result);
        }
        public override bool TryGetIndex(GetIndexBinder binder, object[] indexes, out object result)
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

            var arrayList = result as ArrayList;
            if (arrayList != null && arrayList.Count > 0)
            {
                return arrayList[0] is IDictionary<string, object>
                    ? new List<object>(arrayList.Cast<IDictionary<string, object>>().Select(x => new DynamicJsonObject(x)))
                    : new List<object>(arrayList.Cast<object>());
            }

            return result;
        }
    }
	
	
public	class DBLayer
    {
            //string connectstring="data source=ADMDEVSQL01;initial catalog=UserManagement;user id=connstring;password=gnirtsnnoc321";
			//string    mysqlconnectionString="Server=localhost;userid=root;password=root;Database=Account;Convert Zero Datetime=True"  ;
			MasterDB masterDB;
			
			public DBLayer(MasterDB masterDB)
			{this.masterDB=masterDB;
			}
			
			
            public string getObject(string jsonstr)
            {

                dynamic dyamicobejct = new DynamicJsonObject(jsonstr);
                //string TableName = dyamicobejct["TableNames"]["TableName"];
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

                            resultDynamicJsonObject = resultDynamicJsonObject + GetObject(PrimaryKey, PrimaryValue, obj1,MasterTable);
                        }
                    }
                    else if (obj.Value.GetType().ToString() == "System.String")
                    {

                        string TableName = obj.Value.ToString();

                        string Query = "Select *  from " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
                        
						//MySqlDB objMsSqlDB=new MySqlDB(mysqlconnectionString);
                        System.Data.DataTable dt = masterDB.getQuery(Query);

                        resultDynamicJsonObject.setDataTable(dt, TableName);
						if(dt.Rows.Count==1)
                            setForeKeyData(resultDynamicJsonObject, TableName, MasterTable);
                        else if(dt.Rows.Count>1)
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
            //MySqlDB objMsSqlDB=new MySqlDB(mysqlconnectionString);
              string Query = masterDB.getForeginkeyQuery(TableName);

          System.Data.DataTable  dt = masterDB.getQuery(Query);
            foreach (System.Data.DataRow dr in dt.Rows)
            {
                string FkName = dr["FK_ColumnName"].ToString();
                string FkData =Convert.ToString(resultDynamicJsonObject[FkName]);
                if (FkData != "")
                {
                    
                    Query = "select  *  from  " + dr["PK_TableName"] + " where  " + dr["PK_ColumnName"] + " =" + FkData;
                    if (!MasterTable.Contains(dr["PK_TableName"].ToString()) )
                    {
                        dt = masterDB.getQuery(Query);
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

                        
                        dynamic obj = objDynamicJsonObject.Value;
                        DynamicJsonObject TableData = new DynamicJsonObject(obj);
                        string TableName= objDynamicJsonObject.Key.ToString();
                        masterDB.BeginTran();
                        id = saveRecord(masterDB, TableName, TableData, MasterKeyValue);
                        masterDB.Committ();

                    }
                }
                catch(Exception e)
                {

				}
				  return id;
        }
		
		public int saveRecord(	MasterDB masterDB, string TableName, DynamicJsonObject TableData, DynamicJsonObject MasterKeyValue)
        {
            int Id = 0;
            try
            {
                String PrimaryKey = GetPrimaryKey(TableName);
                DynamicJsonObject DetailTable = new DynamicJsonObject();
                

                System.Data.DataTable tableFielddata = masterDB.GetTable(TableName) ;

                String Query = InsertUpdate(TableName, TableData, MasterKeyValue, DetailTable, tableFielddata);
                
                masterDB.executeQuery(Query);

                if (TableData._dictionary.Keys.Contains(PrimaryKey))
                    MasterKeyValue[PrimaryKey] = TableData[PrimaryKey];
                else
                    MasterKeyValue[PrimaryKey] = 0;

                if (Convert.ToInt32(MasterKeyValue[PrimaryKey]) == 0)
                {
                  
                    
                     MasterKeyValue[PrimaryKey]=masterDB.getInsertLastId();

                }
                SaveDetail(masterDB,DetailTable,MasterKeyValue);

                Id = Convert.ToInt32(MasterKeyValue[PrimaryKey]);
                
            }catch(Exception e)
            {
                masterDB.RollBack();

            }

             return Id;
        }

        public void  SaveDetail(MasterDB objMsSqlDB,DynamicJsonObject  DetailTables, DynamicJsonObject MasterKeyValue)
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
		
        public string deleteObject(string jsonstr)
        {
            return string.Empty;
        }
        public string List(MasterDB masterDB,string TableName,String Query)
        {
            //MySqlDB objMsSqlDB=new MySqlDB(mysqlconnectionString);
            System.Data.DataTable dt = masterDB.getQuery(Query);
            DynamicJsonObject objDynamicJsonObject = new DynamicJsonObject();
            objDynamicJsonObject.setDataTable(dt, TableName);

            return objDynamicJsonObject.ToString();
        }
        public string Query(string jsonstr)
        {
            return string.Empty;

        }

}

#endregion
