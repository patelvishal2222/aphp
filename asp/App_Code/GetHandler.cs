using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Web;

/// <summary>
/// Summary description for GetHandler
/// </summary>
public class GetHandler : IHttpHandler
{
    public GetHandler()
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
            objDataLayer.getObject();
            string data = objDataLayer.getJson();
            context.Response.Write(data);
            // context.Response.StatusCode = 404; 
            context.Response.End();
        }
    }
}