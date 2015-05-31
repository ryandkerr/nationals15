from bs4 import BeautifulSoup
from urllib2 import urlopen
import csv

# code largely based on:
# http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/

BASE_URL = "http://play.usaultimate.org/events/USA-Ultimate-D-I-College-Championships-2015/"

# helper for making soup
def make_soup(url):
    html = urlopen(url).read()
    s = BeautifulSoup(html, "lxml")
    return s

# takes url and returns array of http links to team pages
# returns both men and women team links
def get_team_links(section_url):
    soup = make_soup(section_url)
    team_table = soup.find("div", "eventSponsorInfo").table.find_all("a")

    link_list = []
    for link in team_table:
            link_list.append(link.get("href"))

    return link_list

team_links = get_team_links(BASE_URL)

# with open("nationals15.csv", "wb") as csvout:

master_array = []

def get_rows(team_url):
    soup = make_soup(team_url)
    profile = soup.find("div", "profile_info")
    team_name = profile.h4.get_text(strip=True)
    division = profile.find("dl", id="CT_Main_0_dlGenderDivision").dd.get_text(strip=True)

    team_rows = soup.find("table", "global_table").find_all("tr")

    for i, row in enumerate(team_rows):
        if i > 0:
            r =[team_name, division]
            for cell in row.find_all("td"):
                r.append(cell.get_text(strip=True))
            master_array.append(r)

    # print team_name, division

for team in team_links:
    get_rows(team)

print master_array







