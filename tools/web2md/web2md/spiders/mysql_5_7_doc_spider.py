import scrapy
from scrapy.http import HtmlResponse


class MySQL57DocSpider(scrapy.Spider):
    name = 'mysql57'
    doc_root_url = 'https://dev.mysql.com/doc/refman/5.7/en/'

    def start_requests(self):
        yield scrapy.Request(url=self.doc_root_url, callback=self.parse)

    def parse(self, response: HtmlResponse):
        page = response.url.split("/")[-2]
        filename = 'quotes-%s.html' % page
        with open(filename, 'wb') as f:
            f.write(response.body)
        self.log('Saved file %s' % filename)
