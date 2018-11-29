
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
string    mysqlconnectionString="Server=localhost;userid=root;password=root;Database=Account;Convert Zero Datetime=True"  ;
    public bool IsReusable
    {
        get { return false; }
    }
  
    public void ProcessRequest(HttpContext context)
    {
        //context.Response.Write("<h1 style='Color:#000066'>WelCome To Custom HttpHandler</h1>");
        //context.Response.Write("HttpHandler processed on - " + DateTime.Now.ToString());
		
		
		HttpRequest Request = context.Request;
            HttpResponse Response = context.Response;
             
       //  Response.Write( Request.HttpMethod);
		  if(context.Request.QueryString["Query"]!=null)
            {
			  
				String Query=context.Request.QueryString["Query"];
				 MySqlDB objMsSqlDB=new MySqlDB(mysqlconnectionString);
				 DataTable dt=objMsSqlDB.getQuery(Query);
				 string  webdata =DabaseManager.DataTableTOJson(dt);
				  Response.Write(webdata);
          
			}
			else  if(context.Request.QueryString["getObject"]!=null)
			{
			String getObject=context.Request.QueryString["getObject"].Trim();
			dynamic  dyamicobejct=new  DynamicJsonObject(getObject);
			string TableName="";
			String PrimaryKey=context.Request.QueryString["PrimaryKey"];
			String PrimaryValue=context.Request.QueryString["PrimaryValue"];
			String Query="Select *  FROM "+TableName+" WHERE "+PrimaryKey+"="+PrimaryValue;
				 MySqlDB objMsSqlDB=new MySqlDB(mysqlconnectionString);
				 
				 DataTable dt=objMsSqlDB.getQuery(Query);
				
				
			dynamic  dyamicobejct=new  DynamicJsonObject();
			dyamicobejct.setDataTable(dt);
			   
			
				
			   Query =objMsSqlDB.getForeginkeyQuery(TableName);
			   
			   dt=objMsSqlDB.getQuery(Query);
				foreach(DataRow  dr in dt.Rows)
				{
				  String  FkName=dr["COLUMN_NAME"].ToString();
				  string FkData=dyamicobejct[FkName];
				  if(FkData!="")
				  {
				  Query="select  *  from   "+ dr["REFERENCED_TABLE_NAME"] +" where  "+dr["REFERENCED_COLUMN_NAME"]+" ="+FkData  ;
				     dt=objMsSqlDB.getQuery(Query);
					 dynamic  dyamicsubobejct=new  DynamicJsonObject();
					 
					 dyamicsubobejct.setDataTable(dt);
				  dyamicobejct["Virtual"+FkName.Substring(0,FkName.Length-2)]=dyamicsubobejct;
			
				  	dyamicobejct.RemoveObject(FkName);
					}
				  
				}
				
				  Response.Write(dyamicobejct.ToString());
				
			}
			else  if(context.Request.QueryString["List"]!=null)
			{
			String TableName=context.Request.QueryString["List"];
				String  Query=context.Request.QueryString["Sql"];
				
				
				 MySqlDB objMsSqlDB=new MySqlDB(mysqlconnectionString);
				 DataTable dt=objMsSqlDB.getQuery(Query);
				 string  webdata =DabaseManager.DataTableTOJson(dt);
				  Response.Write(webdata);
			}
			else  if(context.Request.QueryString["deleteObject"]!=null)
			{
			}
			
			else  if(context.Request.QueryString["saveObject"]!=null)
			{
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
public class  MsSqlDB
{

 string _connectionstr;
        SqlConnection objSqlConnection;
        public MsSqlDB(string connectionstr)
        {
            _connectionstr = connectionstr;
            objSqlConnection = new SqlConnection(_connectionstr);

        }
        public DataTable getQuery(string Query)
        {
            

			//SqlConnection cn = new SqlConnection(connectionstring);
            SqlDataAdapter ad=new SqlDataAdapter(Query,objSqlConnection);
                DataTable dt=new DataTable();
                ad.Fill(dt) ;

            return dt;

        }


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


        }

}
public class  MySqlDB
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
		string  Query="SELECT  COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='"+TableName+"'  and  table_schema='"+Schema+"' and REFERENCED_COLUMN_NAME is not null";
		return Query;
		}
		
}



 #region Nested type: DynamicJsonObject
    [Serializable]
    public sealed class DynamicJsonObject : DynamicObject
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
		// public static void RemoveMember(object dynamicObject, string memberName);
  //public static bool TryRemoveMember(object dynamicObject, string memberName, out object removedMember);
		
		public  void RemoveObject(string columnName)
		{
		
			_dictionary.Remove(columnName);
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

    #endregion

	
