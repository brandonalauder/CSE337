import requests, os, bs4

def createNotes(title, link):
    res = requests.get("https://developer.android.com" + link)
    res.raise_for_status()
    soup = bs4.BeautifulSoup(res.text, features="html.parser")
    noteElements = dict()
    tableElements = soup.findAll('tr')

    for element in tableElements:
        noteElement = element.findAll("em")
        if noteElement and element.select("td > code > a"):
            noteText = ""
            for i in noteElement:
                noteText+=i.text
                methodName = element.select("td > code > a")[0].text
                noteElements[methodName] = noteText
    if noteElements:
        with open(path + '/' + os.path.basename(title), 'w') as f:
            for k, v in noteElements.items():
                f.write(str(k) + ':' + str(v) + '\n')
    return



url = 'https://developer.android.com/reference/android/app/package-summary'
path = 'C:/Users/Brandon/Documents/CSE337/CSE337/outFiles'

os.makedirs(path, exist_ok=True)

res = requests.get(url)
res.raise_for_status()
soup = bs4.BeautifulSoup(res.text, features="html.parser")

items = soup.findAll("devsite-expandable-nav")
andriodAppContainer = None
for item in items:
    if item.div.span.text == 'android.app':
        andriodAppContainer=item
linkContainer = andriodAppContainer.findAll("li", {"class":"devsite-nav-item"})
links = dict()
for element in linkContainer:
    if element.a.has_attr("href"):
        link = element.a["href"]
        title = element.a.span.text
        links[title] = link
print('Creating Files...')
for k,v in links.items():
    createNotes(k, v)
print('Done')
