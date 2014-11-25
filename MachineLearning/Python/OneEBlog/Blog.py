
from bs4 import BeautifulSoup
import urllib2
import time
import json

class Blog :
    def __init__(self,url):    
        request = urllib2.Request(url)    
        response = urllib2.urlopen(request)    
        soup = BeautifulSoup(response)    
        self.Date = time.strftime("%Y-%m-%d %H:%M:%S",time.strptime(soup.find("a", attrs = {"rel": "bookmark"}).text.encode('ascii','ignore'),"%B %d, %Y"))   
        self.Author = soup.find("span", attrs = {"class": "author vcard"}).text.encode('ascii','ignore').strip().split(' ,')    
        self.Tags = [object.getText().encode('ascii','ignore') for object in soup.findAll("a", attrs = {"rel": "tag"})]    
        self.Area = [object.getText().encode('ascii','ignore') for object in soup.findAll("a", attrs = {"rel": "category tag"})]    
        [self.Tags.remove(object) for object in self.Area] 
        self.URL = url    
        out=[object.string for object in soup.find("div", attrs = {"class": "entry-content"}).findAll("p")]    
        self.Content = [object.encode('ascii','ignore').strip() for object in out if object is not None]    
        self.Comments = GetComments(url,soup)     

class Comment:
    def __init__(self,obj):    
        try:
            self.Comment = obj.find("p").text.encode('ascii','ignore')    
            self.Author = obj.find("a").text.encode('ascii','ignore')
            self.Date =  time.strftime("%Y-%m-%d %H:%M:%S",time.strptime(obj.find("time").text.encode('ascii','ignore'),"%B %d, %Y at %H:%M %p"))
        except:
            pass

def GetComments(url,soup):
    obj1=soup.find("ol", attrs = {"class": "commentlist"})
    if obj1 is not None:
        obj=obj1.findAll("li")
        return [Comment(object) for object in obj]
    else :
        return ""

def GetBlogs(start,end):
    url="http://blogs.1e.com/page/"
    allurls=[]
    for i in range(start,end):
        tempurl=url+str(i)
        request = urllib2.Request(tempurl)    
        response = urllib2.urlopen(request)    
        soup = BeautifulSoup(response) 
        allblogs = [Blog(k.find("a").get('href')) for k in soup.findAll("article")]
        allurls = allurls + allblogs
    return allurls


