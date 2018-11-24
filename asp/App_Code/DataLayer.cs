using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DataLayer
/// </summary>
public class DataLayer
{
    DataBaseManager objDataBaseManager;
    String tableName;
    String json;
    dynamic ErrorMessage;
    public dynamic JsonObject;
    bool valid;
    public DataLayer(String json, string tableName, DataBaseManager objDataBaseManager)
	{
        this.json = json;
        this.tableName=tableName;
        this.objDataBaseManager = objDataBaseManager;
		
	}
    public string getJson()
    {
        string jsonData = string.Empty;
        try
        {
            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            serializer.RegisterConverters(new[] { new DynamicJsonConverter() });
            DynamicJsonConverter.DynamicJsonObject DynamicJsonObject = JsonObject;
            if (DynamicJsonObject!=null)
            jsonData =DynamicJsonObject.ToString();
        }
        catch(Exception e)
        {
            throw;
        }
        return  jsonData;
    }

    public void getObject()
    {
        valid = true;
        try
        {
          
           
            var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            serializer.RegisterConverters(new[] { new DynamicJsonConverter() });
            JsonObject = serializer.Deserialize(json, typeof(object));
            IDictionary<string, long> keyValue = new Dictionary<string, long>();
            DynamicQuery objDynamicQuery = new DynamicQuery(objDataBaseManager);

          string  strPrimaryColumn = objDataBaseManager.GetPrimaryColumn(tableName);
            if (strPrimaryColumn == string.Empty)
            {
                ErrorMessage = "[" + tableName + "]  is Primary Column not Found ";
                return;
            }
            else
            {
                keyValue.Add(strPrimaryColumn, Convert.ToInt64(JsonObject[strPrimaryColumn]));

            }

          //          objDynamicQuery.getObject(JsonObject, tableName, keyValue);


            JsonObject=objDynamicQuery.GetObject(tableName, Convert.ToInt64(JsonObject[strPrimaryColumn]));
        }
        catch(Exception e)
        {
            throw;
        }


    }

    public bool CheckValidation()
    {


        if (!objDataBaseManager.CheckTableExists(tableName))
        {
            string str = "Table Not Found";
            ErrorMessage = str;

            return false;
        }

        return true;
    }

    public dynamic SaveMaster()
    {
        var serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        serializer.RegisterConverters(new[] { new DynamicJsonConverter() });
        JsonObject = serializer.Deserialize(json, typeof(object));
        IDictionary<string, long> keyValue = new Dictionary<string, long>();
        try
        {
           
            DynamicQuery objDynamicQuery = new DynamicQuery(objDataBaseManager);
            
            objDataBaseManager.BeginTransaction();
            objDynamicQuery.saveObject(JsonObject, tableName, keyValue);
            //tran.Commit();
            objDataBaseManager.commit();
        }
        catch (Exception e)
        {
           // tran.Rollback();
            objDataBaseManager.Rollback();

        }
        finally
        {
            //cn.Close();
            objDataBaseManager.closeConnection();
        }
        return JsonObject;
    }
    public void SaveObject()
    {

        if (CheckValidation())
        {
             SaveMaster();

        }
        else
        {
            valid=false;
        }


      
    }


   
}