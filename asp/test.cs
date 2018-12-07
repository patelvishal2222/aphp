#region DataLayer
    //{"PrimaryValue":"106","PrimaryKey":"TranId","TableNames":{"TableName":"tran","Relation":[{"TableName":"trandetails"},{"TableName":"tranfin"}]}}
    //{"PrimaryValue":"1","PrimaryKey":RoleGroupID,"TableNames":{"TableName":"um.RoleGroupMaster","Relation":[{"TableName":"um.RoleMaster"},{"TableName":" um.UserRoleGroup"}]}}
    class DataLayer
    {
            string connectstring="data source=ADMDEVSQL01;initial catalog=UserManagement;user id=connstring;password=gnirtsnnoc321";

            public string getObject(string jsonstr)
            {

                dynamic dyamicobejct = new DynamicJsonObject(jsonstr);
                //string TableName = dyamicobejct["TableNames"]["TableName"];
                string PrimaryKey = dyamicobejct["PrimaryKey"];
                string PrimaryValue = dyamicobejct["PrimaryValue"]; ;
                
                //string Query = "Select *  from " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
                //MsSQLDB objMsSqlDB = new MsSQLDB(connectstring);
                //System.Data.DataTable dt = objMsSqlDB.getQuery(Query);
                
                //objDynamicJsonObject.setDataTable(dt);
                //Query = objMsSqlDB.getForeginkeyQuery(TableName);
                //dt = objMsSqlDB.getQuery(Query);
                //foreach (System.Data.DataRow dr in dt.Rows)
                //{
                //    String FkName = dr["COLUMN_NAME"].ToString();
                //    string FkData = dyamicobejct[FkName];
                //    if (FkData != "")
                //    {
                //        Query = "select  *  from   " + dr["REFERENCED_TABLE_NAME"] + " where  " + dr["REFERENCED_COLUMN_NAME"] + " =" + FkData;
                //        dt = objMsSqlDB.getQuery(Query);
                //        dynamic dyamicsubobejct = new DynamicJsonObject();

                //        dyamicsubobejct.setDataTable(dt);
                //        dyamicobejct["Virtual" + FkName.Substring(0, FkName.Length - 2)] = dyamicsubobejct;
                //        // Response.Write(Query);
                //        dyamicobejct.RemoveObject(FkName);
                //    }

                //}
                //for (int i = 0; i < dyamicobejct.TableNames.count;i++ )
                System.Collections.IEnumerable d = dyamicobejct.TableNames;
                DynamicJsonObject objDynamicJsonObject = new DynamicJsonObject();
                objDynamicJsonObject = GetObject(PrimaryKey, PrimaryValue, dyamicobejct.TableNames);
                return objDynamicJsonObject.ToString();
            }


            public DynamicJsonObject GetObject(string PrimaryKey,string PrimaryValue,DynamicJsonObject objDynamicJsonObject)
            {
                DynamicJsonObject resultDynamicJsonObject = new DynamicJsonObject();
                foreach (System.Collections.Generic.KeyValuePair<string, object> obj in objDynamicJsonObject)
                {

                    
                        if(obj.Value.GetType().IsArray==true)
                    {
                        DynamicJsonObject obj1 = new DynamicJsonObject();

                         obj1.setObject(obj.Value);
                         resultDynamicJsonObject = resultDynamicJsonObject + GetObject(PrimaryKey, PrimaryValue, obj1);
                    }
                    else if (obj.Value.GetType().ToString() == "System.String")
                    {

                        string TableName = obj.Value.ToString();

                        string Query = "Select *  from " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
                        MsSQLDB objMsSqlDB = new MsSQLDB(connectstring);
                        System.Data.DataTable dt = objMsSqlDB.getQuery(Query);

                        resultDynamicJsonObject.setDataTable(dt, TableName);
                    }
                }
                return resultDynamicJsonObject;
 

            }
        public string saveObject(string jsonstr)
        {
            return string.Empty;
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

    }
    public interface Database
    {

    }
    public class MsSQLDB : Database
    {
         string _connectionstr;
        System.Data.SqlClient.SqlConnection objSqlConnection;
        string DBName = "UserManagement";
        string Schema = "UM";
        public MsSQLDB(string connectionstr)
        {
            _connectionstr = connectionstr;
            objSqlConnection = new System.Data.SqlClient.SqlConnection(_connectionstr);

        }
        public System.Data.DataTable getQuery(string Query)
        {



            System.Data.SqlClient.SqlDataAdapter ad = new System.Data.SqlClient.SqlDataAdapter(Query, objSqlConnection);
            System.Data.DataTable dt = new System.Data.DataTable();
            ad.Fill(dt);

            return dt;

        }
        public string getForeginkeyQuery(String TableName)
        {
            string Query = "SELECT  COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='" + TableName + "'  and  table_schema='" + Schema + "' and REFERENCED_COLUMN_NAME is not null";
            return Query;
        }
    }
    public class MySqlDB : Database
    {
       

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
        public void setObject (object objs)
    {
        
            object[] obj =(object[]) objs;
        for (int i = 0; i < obj.Length; i++)
        {

            System.Collections.Generic.Dictionary<string, object> keydata2 = (System.Collections.Generic.Dictionary<string, object>)obj[i];
            
            System.Collections.Generic.KeyValuePair<string, object> keydata= keydata2.First();
            _dictionary.Add(keydata.Key, keydata.Value );

        }
        //count = _dictionary.Count;
    }
        public static DynamicJsonObject operator +(DynamicJsonObject First, DynamicJsonObject Secoend)
        {
            System.Collections.Generic.IDictionary<string, object> keydata = Secoend._dictionary;



                ((dynamic)First)[keydata.First().Key] = keydata.First().Value;
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
#endregion
