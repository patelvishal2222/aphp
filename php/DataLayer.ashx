<%@ WebHandler Language="C#" CodeBehind="DataLayer.ashx" Class="DataLayer" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
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
public class DataLayer : IHttpHandler
{
    string connectionstring = "Data Source=ADV-WKS-IN-0285\\TEST;Initial Catalog=Account;Persist Security Info=True;User ID=sa;password=Rinal@2018";
    string mysqlconnectionString = "Server=localhost;userid=root;password=root;Database=Account;Convert Zero Datetime=True";
    MasterDB objMsSqlDB = new MySqlDB("Server=localhost;userid=root;password=root;Database=Account;Convert Zero Datetime=True");
    public bool IsReusable
    {
        get { return false; }
    }
    public void ProcessRequest(HttpContext context)
    {
        HttpRequest Request = context.Request;
        HttpResponse Response = context.Response;
        if (Request.HttpMethod == "POST")
        {
            string jsonString = "";
            using (var inputStream = new StreamReader(context.Request.InputStream))
            {
                jsonString = inputStream.ReadToEnd();
            }
            DBLayer objDataLayer = new DBLayer(objMsSqlDB);
            int id = objDataLayer.saveObject(Response, jsonString);
            Response.Write(id);
        }
        else if (context.Request.QueryString["Query"] != null)
        {
            String Query = context.Request.QueryString["Query"];
            DataTable dt = objMsSqlDB.getQuery(Query);
            string webdata = DBLayer.DataTableTOJson(dt);
            Response.Write(webdata);

        }
        else if (context.Request.QueryString["getObject"] != null)
        {
            String strgetObject = context.Request.QueryString["getObject"].Trim();
            DBLayer objDataLayer = new DBLayer(objMsSqlDB);
            Response.Write(objDataLayer.getObject(strgetObject));

        }
        else if (context.Request.QueryString["List"] != null)
        {
            String TableName = context.Request.QueryString["List"];
            String Query = context.Request.QueryString["Sql"];
            DataTable dt = objMsSqlDB.getQuery(Query);
            string webdata = DBLayer.DataTableTOJson(dt);
            Response.Write(webdata);
        }
        else if (context.Request.QueryString["deleteObject"] != null)
        {
            string TableName = context.Request.QueryString["deleteObject"].Trim();
            String PrimaryKey = context.Request.QueryString["PrimaryKey"];
            String PrimaryValue = context.Request.QueryString["PrimaryValue"];
            String Query = "DELETE  FROM " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
            objMsSqlDB.BeginTran();
             objMsSqlDB.executeQuery(Query);
            objMsSqlDB.Committ();
            Response.Write("True");
        }
        else if (context.Request.QueryString["deleteObject1"] != null)
        {
            String strgetObject = context.Request.QueryString["deleteObject1"].Trim();
            DBLayer objDataLayer = new DBLayer(objMsSqlDB);
            Response.Write(objDataLayer.deleteObject(strgetObject));
        }
        else if (context.Request.QueryString["saveObject"] != null)
        {
            String strgetObject = context.Request.QueryString["saveObject"].Trim();
            DBLayer objDataLayer = new DBLayer(objMsSqlDB);
            int id = objDataLayer.saveObject(Response, strgetObject);
            Response.Write(id);
        }
        else if (context.Request.QueryString["getObject2"] != null)
        {
            string TableName = context.Request.QueryString["getObject2"].Trim();
            String PrimaryKey = context.Request.QueryString["PrimaryKey"];
            String PrimaryValue = context.Request.QueryString["PrimaryValue"];
            String Query = "Select *  FROM " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
            DataTable dt = objMsSqlDB.getQuery(Query);
            dynamic dyamicobejct = new DynamicJsonObject();
            dyamicobejct.setDataTable(dt);
            Query = objMsSqlDB.getForeginkeyQuery(TableName);
            dt = objMsSqlDB.getQuery(Query);
            foreach (DataRow dr in dt.Rows)
            {
                String FkName = dr["FK_ColumnName"].ToString();
                string FkData = dyamicobejct[FkName];
                if (FkData != "")
                {
                    Query = "select  *  from   " + dr["PK_TableName"] + " where  " + dr["PK_ColumnName"] + " =" + FkData;
                    dt = objMsSqlDB.getQuery(Query);
                    dynamic dyamicsubobejct = new DynamicJsonObject();
                    dyamicsubobejct.setDataTable(dt);
                    dyamicobejct["Virtual" + FkName.Substring(0, FkName.Length - 2)] = dyamicsubobejct;
                    dyamicobejct.RemoveObject(FkName);
                }
            }
            Response.Write(dyamicobejct.ToString());
        }
        else
        {
            context.Response.Write("ERROR");
        }
    }
}

public abstract class MasterDB
{
    protected string _connectionstr;
    protected string Schema = "Account";
    public abstract DataTable getQuery(string Query);
    public abstract string getForeginkeyQuery(String TableName);
    public abstract void BeginTran();
    public abstract void RollBack();
    public abstract void Committ();
    public abstract System.Data.DataTable GetTable(string TableName);
    public abstract void executeQuery(string Query);
    public abstract int getInsertLastId();
}
public class MsSqlDB : MasterDB
{
    SqlConnection objSqlConnection;
    System.Data.SqlClient.SqlTransaction transaction;
    string DBName = "UserManagement";
    string Schema = "Account";
    public MsSqlDB(string connectionstr)
    {
        _connectionstr = connectionstr;
        objSqlConnection = new SqlConnection(_connectionstr);
    }
    public override DataTable getQuery(string Query)
    {
        SqlDataAdapter ad = new SqlDataAdapter(Query, objSqlConnection);
        DataTable dt = new DataTable();
        ad.Fill(dt);
        return dt;
    }
    public override string getForeginkeyQuery(String TableName)
    {
        string Query = "SELECT  COLUMN_NAME AS FK_ColumnName,REFERENCED_TABLE_NAME AS  PK_TableName,REFERENCED_COLUMN_NAME  AS  PK_ColumnName  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='" + TableName + "'  and  table_schema='" + "' and REFERENCED_COLUMN_NAME is not null";
        return Query;
    }
    public override void BeginTran()
    {
        objSqlConnection = new System.Data.SqlClient.SqlConnection(_connectionstr);
        objSqlConnection.Open();
        transaction = objSqlConnection.BeginTransaction("SampleTransaction");
    }
    public override int getInsertLastId()
    {
        string Query = "select SCOPE_IDENTITY() ";
        return executeReader(Query);
    }
    public override void Committ()
    {
        transaction.Commit();
        objSqlConnection.Close();
    }
    public override void RollBack()
    {
        transaction.Rollback();
        objSqlConnection.Close();
    }
    public override void executeQuery(string Query)
    {
        System.Data.SqlClient.SqlCommand command = objSqlConnection.CreateCommand();
        command.Transaction = transaction;
        command.CommandText = Query;
        command.ExecuteNonQuery();
    }
    public int executeReader(string Query)
    {

        int Id = 0;
        System.Data.SqlClient.SqlCommand command = objSqlConnection.CreateCommand();
        command.Transaction = transaction;
        command.CommandText = Query;
        System.Data.SqlClient.SqlDataReader reader = command.ExecuteReader();
        if (reader.Read())
        {

            Id = Convert.ToInt32(reader[0]);
        }
        reader.Close();
        return Id;
    }
    public override System.Data.DataTable GetTable(String TableName)
    {
        string Query = "select *  from information_schema.COLUMNS  where table_name='" + TableName + "' ";
        return getQuery(Query);
    }
}
public class MySqlDB : MasterDB
{

    MySqlConnection objSqlConnection;
    MySqlConnection objSqlConnection2;
    MySqlTransaction transaction;
    public MySqlDB(string connectionstr)
    {
        _connectionstr = connectionstr;
        objSqlConnection = new MySqlConnection(_connectionstr);
    }
    public override DataTable getQuery(string Query)
    {

        MySqlDataAdapter ad = new MySqlDataAdapter(Query, objSqlConnection);
        DataTable dt = new DataTable();
        ad.Fill(dt);
        return dt;

    }
    public override string getForeginkeyQuery(String TableName)
    {
        string Query = "SELECT  COLUMN_NAME AS FK_ColumnName,REFERENCED_TABLE_NAME AS  PK_TableName,REFERENCED_COLUMN_NAME  AS  PK_ColumnName  FROM information_schema.KEY_COLUMN_USAGE   where  TABLE_NAME='" + TableName + "'  and  table_schema='" + Schema + "' and REFERENCED_COLUMN_NAME is not null";
        return Query;
    }
    public override System.Data.DataTable GetTable(String TableName)
    {
        string Query = "select *  from information_schema.COLUMNS  where table_name='" + TableName + "' ";
        return getQuery(Query);
    }
    public override void BeginTran()
    {
        objSqlConnection2 = new MySqlConnection(_connectionstr);
        objSqlConnection2.Open();
        transaction = objSqlConnection2.BeginTransaction();
    }

    public override void Committ()
    {
        transaction.Commit();
    }

    public override void RollBack()
    {
        transaction.Rollback();
    }

    public override void executeQuery(string Query)
    {
        MySqlCommand command = objSqlConnection2.CreateCommand();
        command.Transaction = transaction;
        command.CommandText = Query;
        command.ExecuteNonQuery();
    }
    public override int getInsertLastId()
    {

        string Query = "SELECT  LAST_INSERT_ID()";
        return executeReader(Query);

    }
    public int executeReader(string Query)
    {

        int Id = 0;
        MySqlCommand command = objSqlConnection2.CreateCommand();
        command.Transaction = transaction;
        command.CommandText = Query;
        MySqlDataReader reader = command.ExecuteReader();
        while (reader.Read())
        {
            Id = Convert.ToInt32(reader[0].ToString());
        }
        reader.Close();
        return Id;
    }

}
#region Nested type: DynamicJsonObject
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
    public DynamicJsonObject()
    {
        _dictionary = new Dictionary<string, object>();
    }

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
    public void setObject(object obj)
    {

        System.Collections.Generic.Dictionary<string, object> keydata2 = (System.Collections.Generic.Dictionary<string, object>)obj;
        System.Collections.Generic.KeyValuePair<string, object> keydata = keydata2.First();
        _dictionary.Add(keydata.Key, keydata.Value);
    }
    public static DynamicJsonObject operator +(DynamicJsonObject First, DynamicJsonObject Secoend)
    {
        if (Secoend == null || First == null)
        {
        }
        else
        {
            System.Collections.Generic.IDictionary<string, object> keydata = Secoend._dictionary;
            if (keydata.Count > 0)
                ((dynamic)First)[keydata.First().Key] = keydata.First().Value;
        }
        return First;
    }
    public DynamicJsonObject(System.Collections.Generic.KeyValuePair<string, object>[] dictionary)
    {
        foreach (var item in dictionary)
            _dictionary.Add(item.Key, item.Value);
        count = _dictionary.Count;
    }
    IEnumerator IEnumerable.GetEnumerator()
    {
        return _dictionary.GetEnumerator();
    }
    public bool isJsonObject(string jsonStr)
    {
        if (jsonStr.Substring(0, 1) == "{" && jsonStr.Substring(jsonStr.Length - 1, 1) == "}")
        {
            return true;
        }
        else
            return false;
    }
    public bool isJsonArray(string jsonStr)
    {
        if (jsonStr.Substring(0, 1) == "[" && jsonStr.Substring(jsonStr.Length - 1, 1) == "]")
        {
            return true;
        }
        else
            return false;
    }

    public bool isJsonField(string jsonStr)
    {
        string[] strObject = jsonStr.Split(':');
        if (strObject.Length > 0)
        {
            return true;
        }
        else
            return false;
    }
    public Dictionary<string, object> jsonObject(string jsonStr)
    {
        Dictionary<string, object> _dictionary = new Dictionary<string, object>();
        if (isJsonObject(jsonStr))
        {
            jsonStr = removeBracket(jsonStr, "{", "}");
            _dictionary["object"] = jsonStr;
            _dictionary = jsonObject(jsonStr);
        }
        else if (isJsonArray(jsonStr))
        {
            _dictionary["arrya"] = jsonStr;
        }
        else if (isJsonField(jsonStr))
        {
            foreach (string strdata in jsonStr.Split(','))
            {
                string[] strObject = strdata.Split(':');
                if (strObject.Length == 2)
                {
                    strObject[0] = removeBracket(strObject[0]);
                    strObject[1] = removeBracket(strObject[1]);
                    _dictionary[strObject[0]] = strObject[1];
                }
                else
                {
                    // strObject[0]=removeBracket(strObject[0]);
                    // strObject[1]=removeBracket(strObject[1]);
                    // _dictionary[ strObject[0]]=strObject[1];
                }
            }
        }
        else
        {
            //_dictionary["data"]=jsonStr;
        }
        return _dictionary;
    }
    public IEnumerable<int> getObjectSplit(string jsonStr)
    {

        for (int i = 0; i < jsonStr.Length; i++)
        {
            if (jsonStr[i] == ',')
            {
                yield return i;
            }
        }
    }
    public string removeBracket(string jsonStr, string startStr = "\"", string endStr = "\"")
    {
        jsonStr = jsonStr.Trim();
        if (jsonStr.Substring(0, 1) == startStr) ;
        {
            jsonStr = jsonStr.Substring(1);
        }
        if (jsonStr.Substring(jsonStr.Length - 1, 1) == endStr) ;
        {
            jsonStr = jsonStr.Substring(0, jsonStr.Length - 1);
        }
        return jsonStr;
    }
    public void RemoveObject(string columnName)
    {
        _dictionary.Remove(columnName);
    }
    public object this[string name]
    {
        get
        {
            return _dictionary[name];
        }
        set
        {
            _dictionary[name] = value;
        }
    }
    public override string ToString()
    {
        var sb = new StringBuilder("{");
        ToString(sb);
        return sb.ToString();
    }
    public void setDataTable(DataTable dt)
    {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            dynamic objDynamicJsonObject = new DynamicJsonObject();
            for (int j = 0; j < dt.Columns.Count; j++)
            {
                if (dt.Rows[i][j].GetType() == typeof(DateTime))
                {
                    _dictionary.Add(dt.Columns[j].ColumnName, Convert.ToDateTime(dt.Rows[i][j]).ToString("dd-MMM-yyyy"));
                    objDynamicJsonObject[dt.Columns[j].ColumnName] = Convert.ToDateTime(dt.Rows[i][j]).ToString("dd-MMM-yyyy");
                }
                else
                {
                    _dictionary.Add(dt.Columns[j].ColumnName, dt.Rows[i][j].ToString());
                    objDynamicJsonObject[dt.Columns[j].ColumnName] = dt.Rows[i][j].ToString();
                }
            }
            arrayList.Add(objDynamicJsonObject);
        }
    }

    public void setDataTable(System.Data.DataTable dt, string tableName, bool dictionaryDetail = false)
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
                    if (dictionaryDetail == true)
                    {
                        objDynamicJsonObject[dt.Columns[j].ColumnName] = dt.Rows[i][j].ToString();
                    }
                    else if (dt.Rows.Count == 1)
                        _dictionary.Add(dt.Columns[j].ColumnName, dt.Rows[i][j].ToString());
                    else
                        objDynamicJsonObject[dt.Columns[j].ColumnName] = dt.Rows[i][j].ToString();
                }
            }
            arrayList.Add(objDynamicJsonObject);

        }
        if (dictionaryDetail == true)
        {
            _dictionary[tableName] = arrayList;
        }
        else if (dt.Rows.Count == 1)
        {
            //_dictionary = ((DynamicJsonObject)arrayList[0])._dictionary;
        }
        else if (dt.Rows.Count > 1)
        {
            _dictionary[tableName] = arrayList;
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
            else if (value.GetType().IsArray == true)
            {
                object[] objCollection = (object[])value;
                sb.Append("\"" + name + "\":[");
                var firstInArray = true;
                foreach (var objectField in objCollection)
                {

                    if (!firstInArray)
                        sb.Append(",");
                    firstInArray = false;

                    new DynamicJsonObject(objectField as IDictionary<string, object>).ToString(sb.Append("{"));
                }
                sb.Append("]");
            }
            else if (value is DBNull)
            {
                sb.AppendFormat("\"{0}\":\"\"", name);
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
            result = null;
            return true;
        }

        result = WrapResultObject(result);
        return true;
    }
    public override bool TrySetMember(SetMemberBinder binder, object result)
    {
        _dictionary[binder.Name] = result;
        return true;
    }
    public override bool TrySetIndex(SetIndexBinder binder, object[] indexes, object result)
    {
        if (indexes.Length == 1 && indexes[0] != null)
        {
            if (indexes.Length > 0)
            {
                string key = indexes[0].ToString();
                _dictionary[key] = result;
                result = null;
                return true;
            }
            return true;
        }
        return base.TrySetIndex(binder, indexes, result);
    }
    public override bool TryGetIndex(GetIndexBinder binder, object[] indexes, out object result)
    {
        if (indexes.Length == 1 && indexes[0] != null)
        {
            if (!_dictionary.TryGetValue(indexes[0].ToString(), out result))
            {
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
public class DBLayer
{

    MasterDB masterDB;
    #region Public Method
    public DBLayer(MasterDB masterDB)
    {
        this.masterDB = masterDB;
    }
    public string getObject(string jsonstr)
    {
        dynamic dyamicobejct = new DynamicJsonObject(jsonstr);
        string PrimaryKey = dyamicobejct["PrimaryKey"];
        string PrimaryValue = dyamicobejct["PrimaryValue"]; ;
        System.Collections.IEnumerable d = dyamicobejct.TableNames;
        DynamicJsonObject objDynamicJsonObject = new DynamicJsonObject();
        ArrayList MasterTable = new ArrayList();
        objDynamicJsonObject = GetObject(PrimaryKey, PrimaryValue, dyamicobejct.TableNames, MasterTable);
        return objDynamicJsonObject.ToString();
    }
    public bool deleteObject(string jsonstr)
    {
        masterDB.BeginTran();
        try
        {
            dynamic dyamicobejct = new DynamicJsonObject(jsonstr);
            string PrimaryKey = dyamicobejct["PrimaryKey"];
            string PrimaryValue = dyamicobejct["PrimaryValue"]; ;
            foreach (System.Collections.Generic.Dictionary<string, object> TableObjectArray in dyamicobejct.TableNames)
            {
                DynamicJsonObject TableObject = new DynamicJsonObject();
                TableObject.setObject(TableObjectArray);
                string TableName = TableObject["TableName"].ToString();
                string Query = "DELETE FROM  " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
                masterDB.executeQuery(Query);
            }
            masterDB.Committ();
        }
        catch (Exception e)
        {
            masterDB.RollBack();
            return false;
        }
        return true;
    }
    public int saveObject(HttpResponse Response, string jsonstr)
    {
        int id = 0;
        try
        {
            DynamicJsonObject DynamicJsonObject = new DynamicJsonObject(jsonstr);
            string str = DynamicJsonObject.ToString();
            foreach (dynamic objDynamicJsonObject in DynamicJsonObject)
            {
                DynamicJsonObject MasterKeyValue = new DynamicJsonObject();
                dynamic obj = objDynamicJsonObject.Value;
                DynamicJsonObject TableData = new DynamicJsonObject(obj);
                string TableName = objDynamicJsonObject.Key.ToString();
                masterDB.BeginTran();
                id = saveRecord(masterDB, TableName, TableData, MasterKeyValue, Response);
                masterDB.Committ();
            }
        }
        catch (Exception e)
        {
            Response.Write(e.ToString());
        }
        return id;
    }
    public static string DataTableTOJson(DataTable dt)
    {
        String webdata = string.Empty;
        webdata = webdata + "{\"listdata\":[";
        foreach (DataRow dr in dt.Rows)
        {
            webdata = webdata + "{";
            foreach (DataColumn dc in dt.Columns)
            {
                if (dr[dc.ColumnName].GetType() == typeof(DateTime))
                {
                    webdata = webdata + "\"" + dc.ColumnName + "\":\"" + Convert.ToDateTime(dr[dc.ColumnName]).ToString("dd-MMM-yyyy") + "\",";
                }
                else
                    webdata = webdata + "\"" + dc.ColumnName + "\":\"" + dr[dc.ColumnName].ToString().Replace(";", "").Replace("\"", "") + "\",";
            }
            webdata = Removelastcomm(webdata);
            webdata = webdata + "},";

        }
        webdata = Removelastcomm(webdata);
        webdata = webdata + "]}";
        return webdata;
    }
    #endregion Public Method
    #region private  Method
 

    private DynamicJsonObject GetObject(string PrimaryKey, string PrimaryValue, DynamicJsonObject objDynamicJsonObject, ArrayList MasterTable, bool dictionaryDetail = false)
    {
        DynamicJsonObject resultDynamicJsonObject = new DynamicJsonObject();
        foreach (System.Collections.Generic.KeyValuePair<string, object> TableNames in objDynamicJsonObject)
        {
            if (TableNames.Value.GetType().IsArray == true)
            {
                object t = TableNames.Value;
                object[] objdata = (object[])t;
                for (int i = 0; i < objdata.Length; i++)
                {
                    DynamicJsonObject objDynamicJsonObject1 = new DynamicJsonObject();
                    objDynamicJsonObject1.setObject(objdata[i]);
                    DynamicJsonObject resultDynamicJsonObject2 = GetObject(PrimaryKey, PrimaryValue, objDynamicJsonObject1, MasterTable, true);
                    resultDynamicJsonObject = resultDynamicJsonObject + resultDynamicJsonObject2;
                }
            }
            else if (TableNames.Value.GetType().ToString() == "System.String")
            {
                string TableName = TableNames.Value.ToString();
                string Query = "Select *  from " + TableName + " WHERE " + PrimaryKey + "=" + PrimaryValue;
                System.Data.DataTable dt = masterDB.getQuery(Query);
                resultDynamicJsonObject.setDataTable(dt, TableName, dictionaryDetail);
                if (dt.Rows.Count == 1 && dictionaryDetail == false)
                    setForeKeyData(resultDynamicJsonObject, TableName, MasterTable);
                else if (dt.Rows.Count > 0)
                {
                    System.Collections.ArrayList objes = (System.Collections.ArrayList)resultDynamicJsonObject[TableName];
                    foreach (dynamic objdata in objes)
                    {
                        setForeKeyData(objdata, TableName, MasterTable);
                    }
                }
                MasterTable.Add(TableName);
            }
        }
        return resultDynamicJsonObject;
    }
    private void setForeKeyData(DynamicJsonObject resultDynamicJsonObject, string TableName, ArrayList MasterTable)
    {
        string Query = masterDB.getForeginkeyQuery(TableName);
        System.Data.DataTable dt = masterDB.getQuery(Query);
        foreach (System.Data.DataRow dr in dt.Rows)
        {
            string FkName = dr["FK_ColumnName"].ToString();
            string FkData = Convert.ToString(resultDynamicJsonObject[FkName]);
            if (FkData != "")
            {
                Query = "select  *  from  " + dr["PK_TableName"] + " where  " + dr["PK_ColumnName"] + " =" + FkData;
                if (!MasterTable.Contains(dr["PK_TableName"].ToString()))
                {
                    dt = masterDB.getQuery(Query);
                    DynamicJsonObject dyamicsubobejct = new DynamicJsonObject();
                    dyamicsubobejct.setDataTable(dt, dr["PK_TableName"].ToString());
                    resultDynamicJsonObject["Virtual" + FkName.Substring(0, FkName.Length - 2)] = dyamicsubobejct;
                    resultDynamicJsonObject.RemoveObject(FkName);
                }
            }
        }
    }
   
    private int saveRecord(MasterDB masterDB, string TableName, DynamicJsonObject TableData, DynamicJsonObject MasterKeyValue, HttpResponse Response)
    {
        int Id = 0;
        try
        {
            String PrimaryKey = GetPrimaryKey(TableName);
            DynamicJsonObject DetailTable = new DynamicJsonObject();
            System.Data.DataTable tableFielddata = masterDB.GetTable(TableName);
            String Query = InsertUpdate(TableName, TableData, MasterKeyValue, DetailTable, tableFielddata);
            masterDB.executeQuery(Query);
            if (TableData._dictionary.Keys.Contains(PrimaryKey))
                MasterKeyValue[PrimaryKey] = TableData[PrimaryKey];
            else
                MasterKeyValue[PrimaryKey] = 0;
            if (Convert.ToInt32(MasterKeyValue[PrimaryKey]) == 0)
            {
                MasterKeyValue[PrimaryKey] = masterDB.getInsertLastId();
            }
            SaveDetail(masterDB, DetailTable, MasterKeyValue, Response);
            Id = Convert.ToInt32(MasterKeyValue[PrimaryKey]);
        }
        catch (Exception e)
        {
            Response.Write(e.ToString());
            masterDB.RollBack();
        }
        return Id;
    }
    private void SaveDetail(MasterDB objMsSqlDB, DynamicJsonObject DetailTables, DynamicJsonObject MasterKeyValue, HttpResponse Response)
    {
        foreach (dynamic DetailTable in DetailTables)
        {
            if (DetailTable.Value.GetType().IsArray == true)
            {
                string TableName = DetailTable.Key.ToString();
                dynamic obj = DetailTable.Value;
                DynamicJsonObject TableData = new DynamicJsonObject(obj[0]);
                int id = saveRecord(objMsSqlDB, TableName, TableData, MasterKeyValue, Response);
            }
            else if (DetailTable.Value != "")
            {
                String Query = DetailTable.Value;
                objMsSqlDB.executeQuery(Query);
            }
        }
    }
    private string GetPrimaryKey(string TableName)
    {
        return TableName + "Id";
    }
    private string InsertUpdate(string TableName, DynamicJsonObject TableData, DynamicJsonObject MasterKeyValue, DynamicJsonObject DetailTable, System.Data.DataTable tableFielddata)
    {
        string Query = string.Empty;
        try
        {
            int LoginId = 1;
            string InsertField = "";
            string InsertValue = "";
            string UpdateFieldValue = "";
            string PrimaryKey = GetPrimaryKey(TableName);
            int PrimaryKeyValue = 0;
            foreach (dynamic masterkeyvalue in MasterKeyValue)
            {
                string insertKey = masterkeyvalue.Key.ToString();
                string insertValue = masterkeyvalue.Value.ToString();
                if (TableData.isJsonArray(insertKey))
                    TableData.RemoveObject(insertKey);
                InsertField = insertKey + ",";
                InsertValue = insertValue + ",";
            }
            foreach (dynamic objdata in TableData)
            {
                dynamic field = objdata.Key;
                dynamic value = objdata.Value;
                if (field == PrimaryKey)
                {
                    PrimaryKeyValue = value;
                }
                else if (isfield(field, tableFielddata))// &&  !$data[substr($key,0,-2)])
                {
                    if (field == "InsertedBy")
                    {
                        InsertField = InsertField + field + ",";
                        InsertValue = InsertValue + "'" + LoginId + "',";
                    }
                    else if (field == "InsertedDate")
                    {
                        InsertField = InsertField + field + ",";
                        InsertValue = InsertValue + "'NOW()',";
                    }
                    else if (field == "ModifiedBy")
                    {
                        UpdateFieldValue = UpdateFieldValue + field + "='" + LoginId + "',";
                    }
                    else if (field == "ModifiedDate")
                    {
                        UpdateFieldValue = UpdateFieldValue + field + "='NOW()',";
                    }
                    else if (Convert.ToString(value) != String.Empty)
                    {
                        InsertField = InsertField + field + ",";
                        if (value.GetType().ToString() == "Date" || value.GetType().ToString() == "DateTime" || IsDate(value))
                        {
                            value = value.Split('T')[0];
                            InsertValue = InsertValue + "'" + value + "',";
                            UpdateFieldValue = UpdateFieldValue + field + "='" + value + "',";
                        }
                        else
                        {
                            InsertValue = InsertValue + "'" + value + "',";
                            UpdateFieldValue = UpdateFieldValue + field + "='" + value + "',";
                        }
                    }
                }
                else if (isVirtualTable(field))
                {
                    string VirtualTable = field.ToString().Substring(7);
                    InsertField = InsertField + VirtualTable + "Id,";
                    InsertValue = InsertValue + "'" + value[VirtualTable + "Id"] + "',";
                    UpdateFieldValue = UpdateFieldValue + VirtualTable + "Id='" + value[VirtualTable + "Id"] + "',";
                }
                else if (isTable(field))
                {
                    //if(is_array($value))
                    //if(count($value)>0)
                    DetailTable[field] = value;
                }
                /*
                else if(substr($key,-3)=="Ids")
                {     if($value!=""  )
                      {
                       $DeleteTable=substr($key,0,-3);
                       $DetailTable[$key]="Delete FROM $DeleteTable WHERE ".$DeleteTable."Id in( ".$value.")";
                      }
                }
                  */
            }
            string InsertFields = InsertField.Substring(0, InsertField.LastIndexOf(','));
            string InsertValues = InsertValue.Substring(0, InsertValue.LastIndexOf(','));
            UpdateFieldValue = UpdateFieldValue.Substring(0, UpdateFieldValue.LastIndexOf(','));
            Query = "";
            if (PrimaryKeyValue == 0)
                Query = "INSERT INTO " + TableName + " (" + InsertFields + ") values (" + InsertValues + ")";
            else
                Query = "UPDATE " + TableName + " SET " + UpdateFieldValue + " where " + PrimaryKey + "= " + PrimaryKeyValue;
        }
        catch (Exception e)
        {

        }
        return Query;
    }
    private bool isfield(string FieldName, System.Data.DataTable tableFielddata)
    {
        try
        {
            System.Data.DataRow[] dr = tableFielddata.Select("column_name='" + FieldName + "'");
            if (dr.Length > 0)
                return true;
            else
            {
                return false;
            }
        }
        catch (Exception e)
        {
            return false;
        }
    }
    private bool IsDate(Object obj)
    {
        string strDate = obj.ToString();
        try
        {
            if (strDate.Contains("-") || strDate.Contains("/") || strDate.Contains("\\"))
            {
                DateTime dt = DateTime.Parse(strDate);
                if ((dt.Month != System.DateTime.Now.Month) || (dt.Day < 1 && dt.Day > 31) || dt.Year != System.DateTime.Now.Year)
                    return false;
                else
                    return true;
            }
            else
                return false;
        }
        catch
        {
            return false;
        }
    }
    private bool isVirtualTable(string tableName)
    {
        if (tableName.Trim().Substring(0, 7).ToLower() == "virtual")
            return true;
        else
            return false;
    }
    private bool isTable(string TableName)
    {
        string Query = "select *  from information_schema.tables where table_Name='" + TableName + "'";
        if (1 == 1)
            return true;
        else
            return false;
    }
    private string List(MasterDB masterDB, string TableName, String Query)
    {
        System.Data.DataTable dt = masterDB.getQuery(Query);
        DynamicJsonObject objDynamicJsonObject = new DynamicJsonObject();
        objDynamicJsonObject.setDataTable(dt, TableName);

        return objDynamicJsonObject.ToString();
    }
    private string Query(string jsonstr)
    {
        return string.Empty;
    }
    
  
     private static string Removelastcomm(string data)
     {
         if (data.LastIndexOf(',') >= 0)
         {
             data = data.Substring(0, data.LastIndexOf(','));
         }
         return data;
     }
    #endregion private Method

}
#endregion
