
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
public class DataLayer:IHttpHandler
{

string connectionstring="Data Source=ADV-WKS-IN-0285\\TEST;Initial Catalog=Account;Persist Security Info=True;User ID=sa;password=Rinal@2018";
string    mysqlconnectionString="Server=localhost;userid=root;password=root;Database=Account"  ;
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
             
            
		  if(context.Request.QueryString["sql"]!=null)
            {
			  
				String sql=context.Request.QueryString["sql"];
				//MsSqlDB objMsSqlDB=new MsSqlDB(connectionstring);
				 //DataTable dt=objMsSqlDB.getQuery(sql);
				 MySqlDB objMsSqlDB=new MySqlDB(mysqlconnectionString);
				 DataTable dt=objMsSqlDB.getQuery(sql);
				 
				 string  webdata =DabaseManager.DataTableTOJson(dt);
				  Response.Write(webdata);
				 
				 
        
              
           
          
			}
			else  if(context.Request.QueryString["getObject"]!=null)
			{
			String getObject=context.Request.QueryString["getObject"];
				context.Response.Write(getObject);
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
            webdata = webdata + "{\"records\":[";
				
                  
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
}
