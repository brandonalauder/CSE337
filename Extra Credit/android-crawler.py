import requests, os, bs4

def createNotes(title, link):   #Searches page for cautionaty notes and writes a file for that page which contains notes
    res = requests.get("https://developer.android.com" + link)
    res.raise_for_status()
    soup = bs4.BeautifulSoup(res.text, features="html.parser")
    noteElements = dict()
    tableElements = soup.findAll('tr')

    for element in tableElements:
        noteElement = element.select("td > p > em")          #'em' tag is used for all cautionary notes
        if noteElement and element.select("td > code > a"):  #'a' contains name of method/constant
            noteText = noteElement[0].text
            methodName = element.select("td > code > a")[0].text
            noteElements[methodName] = noteText
    if noteElements:
        with open(path + '/' + os.path.basename(title), 'w') as f:
            for k, v in noteElements.items():
                f.write(str(k) + ':' + str(v) + '\n')
    return



url = 'https://developer.android.com/reference/android/app/package-summary'
path = 'C:/Users/Brandon/Documents/CSE337/CSE337/outFiles'                  #Change path to directory in which the out files should go

os.makedirs(path, exist_ok=True)

res = requests.get(url)
res.raise_for_status()
soup = bs4.BeautifulSoup(res.text, features="html.parser")

items = soup.findAll("devsite-expandable-nav")
andriodAppContainer = None
for item in items:
    if item.div.span.text == 'android.app':         #Search expandable menus until we find the one with android.app
        andriodAppContainer=item
linkContainer = andriodAppContainer.findAll("li", {"class":"devsite-nav-item"}) #find all nav items which contain the links to the API pages
links = dict()
for element in linkContainer:
    if element.a.has_attr("href"):  #Create dictionary with titles and links to all pages in andoid.app API
        link = element.a["href"]
        title = element.a.span.text
        links[title] = link
print('Creating Files...')
for k,v in links.items():
    createNotes(k, v)
print('Done')
