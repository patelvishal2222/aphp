using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DataBaseManager
/// </summary>
public class DataBaseManager
{
    SqlConnection cn;
    SqlConnection tempcn;
    SqlTransaction tran;
	public DataBaseManager(string connectionString)
	{

        cn = new SqlConnection(connectionString);
        tempcn = new SqlConnection(connectionString);
	}


    
    public void ExecuteNonQueryWihTran(string sql)
    {
          SqlCommand cmd = new SqlCommand(sql, cn);
          
            cmd.Transaction = tran;
            cmd.ExecuteNonQuery();
}

    public string GetPrimaryColumn(string tableName)
    {
        string sqlPrimaryColumn = "select COLUMN_NAME  from INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE cu on tc.CONSTRAINT_NAME=cu.CONSTRAINT_NAME where  CONSTRAINT_TYPE='PRIMARY KEY' AND tc.TABLE_NAME='" + tableName + "'";
        string strPrimaryColumn = Convert.ToString(this.getScalerValue(sqlPrimaryColumn));
        return strPrimaryColumn;
    }
    public DataTable getForeginKeyTable(string critria)
    {
        string sql = "select os.name FK_TABLE,cs.name FK_COLUMN, od.name AS PK_TABLE,cd.name as PK_COLUMN,fk.type,fk.type_desc ";
        sql += "from sys.foreign_keys fk ";
        sql += "inner join  sys.foreign_key_columns fkc on fk.object_id=fkc.constraint_object_id ";
        sql += "inner join  sys.objects os  on fkc.parent_object_id=os.object_id ";
        sql += "inner join sys.columns cs on os.object_id=cs.object_id and fkc.parent_column_id=cs.column_id ";
        sql += "inner join sys.objects od on fkc.referenced_object_id=od.object_id ";
        sql += "inner join sys.columns cd on od.object_id=cd.object_id and fkc.referenced_column_id=cd.column_id ";
        sql += " where 1=1  ";
        if (critria!=string.Empty )
        {
            sql += " AND "+critria;

        }


        
        return getDataTable(sql);

    }
    public string GetIdentityColumn(string tableName)
    {
        string sqlIdentiyColumn = "select c.name  from sys.schemas s inner join sys.tables t on t.schema_id=s.schema_id inner join sys.columns c on c.object_id=t.object_id  inner join sys.identity_columns ic on ic.object_id=t.object_id and ic.column_id=c.column_id  where t.name='" + tableName + "' ";
        string strIdentityColumn = Convert.ToString(this.getScalerValue(sqlIdentiyColumn));
        return strIdentityColumn;
    }

    public object getScalerValuewithTran(String sql)
    {


        SqlCommand cmd = new SqlCommand(sql,cn);
        cmd.Transaction = tran;
        try
        {
            return cmd.ExecuteScalar();

        }
        catch (Exception e)
        {

        }
        finally
        {
           
        }

        return null;

    }

    public void BeginTransaction()
    {
        cn.Open();
         tran = cn.BeginTransaction();

    }
    public void commit()
    {
       
         tran.Commit();
    }
    public void Rollback()
    {
       
         tran.Rollback();
    }
    public void closeConnection()
    {
        cn.Close();
    }

    public object getScalerValue(String sql)
    {


        SqlCommand cmd = new SqlCommand(sql, tempcn);
        tempcn.Open();
        try
        {
            return cmd.ExecuteScalar();

        }
        catch (Exception e)
        {

        }
        finally
        {
            tempcn.Close();
        }

        return null;

    }
    public bool CheckTableExists(String tableName)
    {
       return  Convert.ToBoolean(this.getScalerValue("select 1  from sys.Tables  where name= '" + tableName.Replace("[","").Replace("]","") + "'"));
    }
    public bool CheckFieldExists(string fieldName, String tableName)
    {
        string sql = "select 1  from sys.columns  c inner join sys.tables t on c.object_id=t.object_id where c.name='" + fieldName + "' and t.name='" + tableName + "'";
        return Convert.ToBoolean(this.getScalerValue(sql));
    }

    public DataTable getDataTable(string sql)
    {
        SqlDataAdapter ad = new SqlDataAdapter(sql, tempcn);

        DataTable dt = new DataTable();
        ad.Fill(dt);
        return dt;


    }
}