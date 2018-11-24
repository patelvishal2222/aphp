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
/// Summary description for MyLogModule
/// </summary>
public class MyBModule : IHttpModule
{
	public MyBModule()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public void Dispose()
    {
        
    }

    public void Init(HttpApplication context)
    {
        context.BeginRequest += new EventHandler(context_BeginRequest);
        context.PreRequestHandlerExecute += new EventHandler(context_PreRequestHandlerExecute);
        context.EndRequest += new EventHandler(context_EndRequest);
        context.AuthorizeRequest += new EventHandler(context_AuthorizeRequest);
    }

    void context_AuthorizeRequest(object sender, EventArgs e)
    {
        //We change uri for invoking correct handler
        HttpContext context = ((HttpApplication)sender).Context;

        if (context.Request.RawUrl.Contains(".bspx"))
        {
            string url = context.Request.RawUrl.Replace(".bspx", ".aspx");
            context.RewritePath(url);
        }
    }

    void context_PreRequestHandlerExecute(object sender, EventArgs e)
    {
        //We set back the original url on browser
        HttpContext context = ((HttpApplication)sender).Context;

        if (context.Items["originalUrl"] != null)
        {
            context.RewritePath((string)context.Items["originalUrl"]);
        }
    }

    void context_EndRequest(object sender, EventArgs e)
    {
        //We processed the request
    }

    void context_BeginRequest(object sender, EventArgs e)
    {
        //We recived a request, so we save the original URL here
        HttpContext context = ((HttpApplication)sender).Context;

        if (context.Request.RawUrl.Contains(".bspx"))
        {            
            context.Items["originalUrl"] = context.Request.RawUrl;            
        }        
    }
}
