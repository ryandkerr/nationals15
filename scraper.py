from bs4 import BeautifulSoup
from urllib2 import urlopen

# code largely based on:
# http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/

BASE_URL = "http://play.usaultimate.org/events/USA-Ultimate-D-I-College-Championships-2015/"

def get_team_links(section_url):
    html = urlopen(section_url).read()
    soup = BeautifulSoup(html, "lxml")
    team_table = soup.find("div", "eventSponsorInfo").table.find_all("a")

    link_list = []
    for i, link in enumerate(team_table):
        if i%2 == 0:
            link_list.append(link.get("href"))

    print link_list

get_team_links(BASE_URL)





