from bs4 import BeautifulSoup
from urllib2 import urlopen
import csv

# code largely based on:
# http://www.gregreda.com/2013/03/03/web-scraping-101-with-python/

BASE_URL = "http://play.usaultimate.org/events/USA-Ultimate-D-I-College-Championships-2015/"

# takes url and returns array of http links to team pages
# returns both men and women team links
def get_team_links(section_url):
    html = urlopen(section_url).read()
    soup = BeautifulSoup(html, "lxml")
    team_table = soup.find("div", "eventSponsorInfo").table.find_all("a")

    link_list = []
    for link in team_table:
            link_list.append(link.get("href"))

    return link_list

team_links = get_team_links(BASE_URL)

# with open("nationals15.csv", "wb") as csvout:

master_array = []

def get_rows(team_url):
    html = urlopen(team_url).read()
    soup = BeautifulSoup(html, "lxml")
    team_name = soup.find("div", "profile_info").h4.string

    # team_table = soup.find("table", "global_table")

    print team_name

get_rows(team_links[3])







