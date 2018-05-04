public class DumyClass 
{
    public String data{get; set;}
    
    public pageReference display()
    {
        PageReference pageRef = ApexPages.currentPage();

        return pageRef;
    
    }
}