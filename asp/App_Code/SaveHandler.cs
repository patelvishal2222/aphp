using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;

/// <summary>
/// Summary description for SaveHandler
/// </summary>
public class SaveHandler : IHttpHandler
{
	public SaveHandler()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public bool IsReusable
    {
        get { return false; }
    }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string json = new StreamReader(context.Request.InputStream).ReadToEnd();
      
        context.Response.Clear();
        
        DataBaseManager objDataBaseManager = new DataBaseManager(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        if (context.Request.QueryString.Count > 0)
        {
            string tableName = context.Request.QueryString[0].ToString();

            DataLayer objDataLayer = new DataLayer(json, tableName, objDataBaseManager);





            objDataLayer.SaveObject();
       context.Response.Write(objDataLayer.getJson());
      // context.Response.StatusCode = 404; 
            context.Response.End();

        }
    }
}