using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.Web.Script.Serialization;

//https://github.com/kashifimran/math-editor

    public dynamic jsonToObject(string strjson)
    {
        ExpandoJSONConverter d = new ExpandoJSONConverter();
        System.Web.Script.Serialization.JavaScriptSerializer j = new System.Web.Script.Serialization.JavaScriptSerializer();
        dynamic objectdata = j.Deserialize(strjson, typeof(object));

        dynamic result = new Dictionary<string, object>();
        foreach (dynamic obj in objectdata)
        {

          
            dynamic dictionary = obj.Value as IDictionary<string, object>;
            if (dictionary==null)
            result.Add(obj.Key,obj.Value) ;
            else
            {
                dynamic objectData = dynamicobject(dictionary);
                result.Add(obj.Key, objectData);
            }
            
        }
       // result = dynamicobject(objectdata);
        return result;


    }


    public dynamic dynamicobject(dynamic objectdata )
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



[Serializable]
public sealed class DynamicJsonConverter : JavaScriptConverter
{
    public override object Deserialize(IDictionary<string, object> dictionary, Type type, JavaScriptSerializer serializer)
    {
        if (dictionary == null)
            throw new ArgumentNullException("dictionary");

        return type == typeof(object) ? new DynamicJsonObject(dictionary) : null;
    }

    public override IDictionary<string, object> Serialize(object obj, JavaScriptSerializer serializer)
    {
       // throw new NotImplementedException();


        if (obj == null)
            throw new ArgumentNullException("dictionary");
        //StringBuilder str = new StringBuilder();
       
            DynamicJsonConverter.DynamicJsonObject DynamicJsonObject = (DynamicJsonObject)obj;
       
       

        return DynamicJsonObject._dictionary;


    }

    public override IEnumerable<Type> SupportedTypes
    {
        get { return new Collection<Type>(new List<Type>(new[] { typeof(object) })); }
    }

    #region Nested type: DynamicJsonObject
    [Serializable]
    public sealed class DynamicJsonObject : DynamicObject
    {
        public readonly IDictionary<string, object> _dictionary;
        public int count=0;
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

        public override string ToString()
        {
            var sb = new StringBuilder("{");
            ToString(sb);
            return sb.ToString();
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
                    //sb.AppendFormat("{0}:\"{1}\"", name, value);
                    
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
                else if( value is System.Collections.Generic.List<object > )
                {
                    var objCollection = value as System.Collections.Generic.List<object>;
                    sb.Append("\"" + name + "\":[");
                    var firstInArray = true;
                    foreach (var objectField in objCollection)
                    {

                        if (!firstInArray)
                            sb.Append(",");
                        firstInArray = false;
                        new DynamicJsonObject((IDictionary<string, object>)((DynamicJsonConverter.DynamicJsonObject)(objectField))._dictionary).ToString(sb.Append("{"));
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
                else if (value is DBNull)
                {
                    sb.AppendFormat("\"{0}\":\"\"", name);
                    //sb.AppendFormat("\"{0}\":0", name);
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
                // return null to avoid exception.  caller can check for null this way...
                result = null;
                return true;
            }

            result = WrapResultObject(result);
            return true;
        }
       
        

        public override bool TrySetMember(SetMemberBinder binder, object result)
        {

           
           // _dictionary.Remove(binder.Name);
           // _dictionary.Add(binder.Name, result);
           // base.TrySetMember(binder, result);
            _dictionary[binder.Name] = result;
            return true;
        }


     
        
        public override bool TrySetIndex(SetIndexBinder binder, object[] indexes, object result)
        {

            if (indexes.Length == 1 && indexes[0] != null)
            {
               if (indexes.Length >0)
               {
                   string key = indexes[0].ToString();
                   _dictionary[key] = result;
                    //_dictionary.Remove(key);
                    //_dictionary.Add(key, result);
                    result = null;
                    return true;
                }

                
                return true;
            }

            return base.TrySetIndex(binder, indexes,  result);
        }
        public override bool TryGetIndex(GetIndexBinder binder, object[] indexes, out object result)
        {
            if (indexes.Length == 1 && indexes[0] != null)
            {
                if (!_dictionary.TryGetValue(indexes[0].ToString(), out result))
                {
                    // return null to avoid exception.  caller can check for null this way...
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

    #endregion
}
