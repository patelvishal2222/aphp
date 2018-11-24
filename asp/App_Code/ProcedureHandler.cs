using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;


/// <summary>
/// Summary description for QueryHandler
/// </summary>
public class ProcedureHandler : IHttpHandler
{
	public ProcedureHandler()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public bool IsReusable
    {
        get { return false; }
    }

    public String RemoveLastComm(String str)
    {

        if(str.LastIndexOf(",")>0)
        {

            str = str.Substring(0, str.LastIndexOf(","));
        }
            return str;
    }
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        if (context.Request.QueryString.Count>0  )
        {
            string sql = context.Request.QueryString[0].ToString();
            context.Response.Clear();
            SqlConnection cn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            SqlCommand cmd = new SqlCommand(sql,cn);
            string webdata = string.Empty;
            try
            {
                cn.Open();

                cmd.CommandType = CommandType.StoredProcedure;
                 SqlDataReader sr= cmd.ExecuteReader();
                 webdata = "{\"records\": [";
                while(sr.Read())
                {
                    int count=sr.FieldCount;
                    //webdata = webdata+"[";
                    
                    //for (int i = 0; i < count; i++)
                    //{
                    //    webdata =webdata+ sr.GetName(i);
                    //    if (i < count - 1)
                    //        webdata = webdata + ",";
                    //}
                    //webdata = webdata + "]";
                    

                    webdata = webdata + "{";
                    for (int i = 0; i < sr.FieldCount; i++)
                    {
                        
                        webdata = webdata + "\""+sr.GetName(i) + "\":\"" + sr[i]+"\",";
                        
                            
                    }
                    webdata = RemoveLastComm(webdata);
                    webdata = webdata + "},";
                }
                webdata = RemoveLastComm(webdata);
                webdata = webdata + "]}";

               
            }
            catch(Exception e)
            {

            }
            finally
            {
                cn.Close();
            }

            context.Response.Write(webdata);
            //context.Response.Write("vishal");
            context.Response.End();
            
        }
    }
}