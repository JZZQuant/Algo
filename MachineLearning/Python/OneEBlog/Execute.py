import Blog
import json

def scrap(start,end):
    net = Blog.GetBlogs(start,end)
    outputfile = r'c:\scrap_' + str(start) + ".txt"
    file = open(outputfile, 'w+')
    file.write(json.dumps(net, default=lambda o: o.__dict__))
    file.close()
    
if __name__ == "__main__":
    import sys
    start = int(sys.argv[1])
    end = int(sys.argv[2])
    print(scrap(start,end))
