public class avalaraController2 {
    public static String avalara_customsetting  {get; set;}
    public static String avalara_password  {get; set;}
    public static String avalara_accountnumber  {get; set;}
    public static String avalara_endpoint {get; set;}
        
    //string variable to show api result
    public string result{get;set;}
    //string variable to hold amount of line item
    public String amount { get; set; }
    //string varriable to hold quantity of line item
    public String count { get; set; }
    
    //string varriable to hold total amount
    public String total { get; set; }  
    //string varriable to hold postal code of address
    public String PostalCode { get; set; }
    //line 1 of address
    public String Line1 { get; set; }
    //line 2 of address
    public String Line2 { get; set; }
    //line 1 of address
    public String city { get; set; }
    //line 2 of address
    public String state { get; set; }
    
    public String country { get; set; }  
    
 
     //string varriable to hold postal code of address
    public String from_PostalCode { get; set; }
   
    public string getAVATAXInfo(){
  
         
        system.debug('Line1 =========> '+ Line1);
        system.debug('Line2 =========> '+ Line2 );
        
        system.debug('city =========> '+ city);
        
        system.debug('state =========> '+ state );
        
        system.debug('PostalCode =========> '+ PostalCode);
        
        system.debug('country =========> '+ country);
        
        system.debug('total =========> '+ total);
        
        
        
        XC_Avalara_tax xAva = new XC_Avalara_tax( );
        String result = xAva.getAvalaraTaxInfo(Line1, Line2, city, state, PostalCode, country, total);
    	return result;
    }
}