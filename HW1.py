#Brandon Lauder

#Problem 1

def isValid(input):
    dict = {}                              #Put characters into a dictionary to count each character then put counted number of characters into a list
    for char in input:
        if char in dict:
            dict[char] = dict[char]+1
        else:
            dict[char] = 1
    values = [v for k,v in dict.items()]
    print(values)

    for i in values:                    #Check if all values are equal and print yes if they are
        for n in values:
            if i!=n:
                break
        else:
            continue
        break
    else:
        return 'YES'

    for index1, i in enumerate(values):         #Check if subtracting 1 from a value would make them all equal and print yes if it would or else print no
        for index2, j in enumerate(values):
            if ((i-1)!=j) & (index1!=index2):   #exclude self checking
                break
        else:
            return 'YES'
    return 'NO'

#Problem 2

def isBalanced(s):
    stack=[]
    list = [x for x in s]
    for x in list:
        if (x in ['(', '[', '{']):  #add all opening brackets to stack
            stack.append(x)
        elif not stack:           #if stack is empty then that means closed brackets were not opened and therefore unbalanced
                return 'NO'
        else:
            i = stack.pop()
            if((i=='(')&(x!=')')):  #check if closing parenthesis matches bracket from the top of stack
                return 'NO'
            if((i=='[')&(x!=']')):
                return 'NO'
            if((i=='{')&(x!='}')):
                return 'NO'
    if not stack:                   #if stack is not empty then that means there exists open brackets that were not closed
        return 'YES'
    else:
        return 'NO'


#Problem 3

class Node:

    def __init__(self, name, left=None, right=None):
        self.name=name
        self.left=left
        self.right=right


    def preOrder(self, preOrderList=None):  #create a new list if not given and recursively pass the list to each child node to append
        if preOrderList is None:
            preOrderList = []
        preOrderList.append(self.name)              #append root
        if(self.left!=None):                        #stopping case
            Node.preOrder(self.left, preOrderList)  #traverse left
        if(self.right!=None):
            Node.preOrder(self.right, preOrderList)
        return preOrderList

    def inOrder(self, inOrderList=None):
        if inOrderList is None:
            inOrderList=[]
        if(self.left!=None):
            Node.inOrder(self.left, inOrderList)
        inOrderList.append(self.name)
        if(self.right!=None):
            Node.inOrder(self.right, inOrderList)
        return inOrderList

    def postOrder(self, postOrderList=None):
        if postOrderList is None:
            postOrderList = []
        if(self.left!=None):
            Node.postOrder(self.left, postOrderList)
        if(self.right!=None):
            Node.postOrder(self.right, postOrderList)
        postOrderList.append(self.name)
        return postOrderList

    def sumTree(self, sum=0):                   #use traversal function to create the list of nodes and sum them
        for i in self.postOrder():
            sum=sum+i
        return sum


print(isValid('aabbcd'))
print(isValid('aabbcdddeefghi'))
print(isValid('abcdefghhgfedecba'))

print(isBalanced('{[()]}'))
print(isBalanced('{[(])}'))
print(isBalanced('{{[[(())]]}}'))
print(isBalanced('{(())]]}}'))
print(isBalanced('{{[[(())]'))

root = Node(2, Node(1,Node(6), Node(3)), Node(3, None, Node(9)))
print(root.preOrder())
print(root.inOrder())
print(root.postOrder())
print(root.sumTree())

root=Node(1,Node(2,	Node(3)),Node(4,None,(Node(5,None,Node(6,None,Node(7))))))
print(root.preOrder())
print(root.inOrder())
print(root.postOrder())
print(root.sumTree())
