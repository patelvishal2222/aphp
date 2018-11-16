
<%@ WebHandler Language="C#" CodeBehind="DataLayer.ashx" Class="DataLayer" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using  System.IO;
using System.Data;
using System.Data.SqlClient;
public class DataLayer:IHttpHandler
{
    public bool IsReusable
    {
        get { return false; }
    }
  public string Removelastcomm(string data)
            {
                if (data.LastIndexOf(',') >=0)
                {
                    data = data.Substring(0, data.LastIndexOf(','));
                }
            return data;
        }
    public void ProcessRequest(HttpContext context)
    {
        //context.Response.Write("<h1 style='Color:#000066'>WelCome To Custom HttpHandler</h1>");
        //context.Response.Write("HttpHandler processed on - " + DateTime.Now.ToString());
		
		
		HttpRequest Request = context.Request;
            HttpResponse Response = context.Response;
             
            
		  if(context.Request.QueryString["sql"]!=null)
            {
			  
				String webdata = string.Empty;
            webdata = webdata + "{\"records\":[";
				
				String sql=context.Request.QueryString["sql"];
            SqlConnection cn = new SqlConnection("Data Source=ADV-WKS-IN-0285\\TEST;Initial Catalog=Account;Persist Security Info=True;User ID=sa;password=Rinal@2018");
            SqlDataAdapter ad=new SqlDataAdapter(sql,cn);
                DataTable dt=new DataTable();
                ad.Fill(dt) ;

                //webdata = webdata + "{";
                //  foreach (DataColumn dc in dt.Columns)
                //  {
                      

                //     webdata=webdata+dc.ColumnName+",";
                  
                //  }
                //  webdata = Removelastcomm(webdata);
                //  webdata = webdata + "},";
                  
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
