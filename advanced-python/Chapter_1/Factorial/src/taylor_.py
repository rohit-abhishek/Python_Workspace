def factorial(x):

    if x == 0: 
        return 1.0
    return x * factorial(x-1)


def talyor_exp(x):

    return [1.0 / factorial(i) for i in range(x)]

def talyor_sin(x):

    res = [] 
    for i in range(x):
        if i % 2 == 1 :
            res.append((-1)**((i-1)/2)/ float(factorial(i)))

        else:
            res.append(0.0)

    return res


def benchmark():
    talyor_exp(500)
    talyor_sin(500)


if __name__ == "__main__":
    benchmark()
