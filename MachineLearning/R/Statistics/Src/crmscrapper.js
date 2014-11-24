var request = require('request');
var cheerio = require('cheerio');


var pages = 500;
header = "url,title,tags";
m = 0;
for (var i = 1; i <= pages; i++) {
    var url = "https://www.odesk.com/o/jobs/browse/st/-1/?q=CRM&page=" + i;
   request(url,  function (error, response, html) {
        if (!error && response.statusCode == 200) {
            var $ = cheerio.load(html);
            $('a.notranslate').each(function (k, element) {
                if ($(this).parent().parent().parent().attr('class') != 'oBd') return;
                var url2 = 'https://www.odesk.com' + $(this).attr('href');
                var title = $(this).text().replace(/,/gi, ';');
                var tags = [];
                $(this).parent().parent().parent().parent().find('li.oSkillListItem').each(function (j, elem) {
                    tags[j] = $(this).children().text();
                });

                var row1 = "\n"+url2 + "," + title+','+ tags.join(';') ;
                header = header + row1;
            });
        }

        m++;
        if (m == pages) {
            var fs = require('fs');
            writeStream = fs.createWriteStream("C:\\Users\\Sasikanth.Raghava\\Documents\\file.csv");
            writeStream.write(header);            
            writeStream.close();
        }

    }, header,m,pages);
}


