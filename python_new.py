
# ask for user Input. which must be array/List of Numbers seperated with commas
rawUserInput = input("enter all Numbers? ").split(",")


# initialise some variables that will later be used in the code
rawUserListInput = []
meanDeviationList = []
standardDeviationList = []
listOfDeiationItems = []
mean = 0
median = 0
rangeInTheList = 0
meanDeviation = 0
standardDeviation = 0
coOfDeviation = 0


# loops through all userInputs and add all item to another list
# this is done so that each item will be able to be converted to an interger
for i in rawUserInput:
# append wach item to the list we initialised previously
    rawUserListInput.append(int(i))


# get the mean of all the Numbers by summing them together 
# and dividing them with the length of the list
mean = sum(rawUserListInput) / len(rawUserListInput)


# the variable getMedian is used here for checking if the length of the list
# can be divisible by 2 to know if the length is even or odd number
getMedian = len(rawUserListInput) % 2

# if it is not equal to 0 , it is an odd Number
if(getMedian != 0):
# the median is gotten her by dividing the length of the list into 2,
# convert it into an whole number integer and use it to get
# the index of the middle number in the list
    median = rawUserListInput[int(len(rawUserListInput)/2)]
else:
# else if getMedian is equal to 0
# a variable is created here to store the length of the rawUserListInput
    userListInputLength = len(rawUserListInput)
# the stored Length is then divided by 2
    halfofLength = userListInputLength / 2
# To get the precise index/position of the two middle Numbers,
# 1 is removed from half of the userListInputLength to get the index of the first middle number.
# And the index of the second middle number is going to be exactly half the length of the List.
# this is because in programming, the machine starts counting from 0
# These two Numbers are then added together and divided by two to get The median
    middleNumberSum = rawUserListInput[int(halfofLength - 1)] + rawUserListInput[int(halfofLength)]
    median = middleNumberSum /2
    
# The max and min of the rawUserListInput is used to compute the range
rangeInTheList = max(rawUserListInput) - min(rawUserListInput)

# a for loop is run again to get some of the initialised List
for i in rawUserListInput:
    newListItem = (i - mean)
    standardDeviationList.append(newListItem * newListItem)
    meanDeviationList.append(abs(newListItem))
    listOfDeiationItems.append(newListItem)

    

# meanDeviation is gotten from the sum of the meanDeviationList and divided by the Length
meanDeviation = sum(meanDeviationList) / len(meanDeviationList)

# standardDeviation is gotten from the square root of the sum of standardDeviationList 
# divided by the length. this could also be done by importing the math library and using
# a predefined python function sqrt(x).
standardDeviation = (sum(standardDeviationList) / len(standardDeviationList))**0.5
# coefficient of deviation
coOfDeviation = (standardDeviation / mean ) * 100


# this is a function to compute the centralMomment
# where x is the power 
def centralMomment(x):
# a new List initialised to be used later in the code
    momentList = []
# a for loop is run against the listOfDeiationItems which we added new Items to
# in the last for loop. the new items are the results we get from removing the mean 
# from each Number in the rawUserListInput
    for i in listOfDeiationItems:
# each item is raised to the power of x
        raisedSolution = i ** x
# and added to the new list we created earlier 
        momentList.append(raisedSolution)
# the List is summed together and divided by the Length of the List
# and the result is returned
    result = sum(momentList)/len(momentList)
    return result





# the centralMomments are computed using the function we defined above
# each with their powers
centralMomment1 = centralMomment(1)
centralMomment2 = centralMomment(2)
centralMomment3 = centralMomment(3)
centralMomment4 = centralMomment(4)








    
    
    
