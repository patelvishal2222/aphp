using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for JpegHandler
/// </summary>
public class CspxHandler :IHttpHandler
{
	public CspxHandler()
	{
		
	}

    public bool IsReusable
    {
        get { return false; }
    }

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        if (context.Request.RawUrl.Contains(".cspx"))
        {
            string newUrl = context.Request.RawUrl.Replace(".cspx", ".aspx");
            context.Server.Transfer(newUrl);
        }        
    }

}
