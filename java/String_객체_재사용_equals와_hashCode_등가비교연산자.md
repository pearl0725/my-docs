## String Constant Pool is?
Java에서 String 객체를 생성하는 방법에는 두 가지 방법이 있습니다.

<br>
- 첫번째 방법

**String literal 로 선언한 객체(상수풀)**
```
String data = "String literal 로 선언한 객체, 데이터가 동일하면 동일한 메모리 주소를 바라봅니다.";
```

<br>
- 두번째 방법

**new 키워드를 이용해 객체를 생성**
```
String data = new String("String 객체 생성");
```

<br>

String literal 로 생성한 객체는 데이터가 동일하다면 같은 객체를 재사용합니다.


자바에서는 Constant Pool 이라는 것이 존재하기 때문인데요, 이 Pool 은 자바에서는 객체를 재사용하기 위해서 Constant Pool 이라는 것이 만들어져 있고, String 의 경우엔 동일한 데이터를 가지는 객체가 있으면 이미 만든 객체를 재사용합니다.

즉, 하기 코드와 같이 생성한 data 객체와 data1 객체는 같은 메모리 참조값을 가지고 있는 **동일한 객체**입니다.

<br>

```
String data = "String 객체 생성";
String data2 = "String 객체 생성";
```

<br>

동일한 메모리 주소를 가지고 있는지 테스트를 하기 위하여 하기의 코드와 같이 작성해보았습니다.

- StringDataSame 메서드는 String literal 방식으로 String 객체를 생성
- StringNewDataSame 메서드는 new 키워드로 객체를 생성

<br>

```
public void stringDataSame() {
        String data = "data";
        String data2 = "data";

        if (data == data2)
            System.out.println("result is same");
        else
            System.out.println("result is different");

        if (data.equals(data2))
            System.out.println("result is same");
        else
            System.out.println("result is different");
    }

    public void stringNewDataSame() {
        String data = new String("data");
        String data2 = new String("data");

        if (data == data2)
            System.out.println("result is same");
        else
            System.out.println("result is different");

        if (data.equals(data2))
            System.out.println("result is same");
        else
            System.out.println("result is different");
    }

```

<br>

출력되는 결과는 하기와 같습니다.

<br>


```
result is same
result is same
result is different
result is same
```

<br>

두번째 방법을 이용해 생성자를 호출하여 객체를 생성하면, 데이터가 동일한 String 객체를 생성하여도 Constant Pool 의 값을 재사용하지 않고 별도의 객체를 생성합니다.

<br>
<br>

## hashCode() 메서드를 이용하여 비교


이번엔 같은 메모리 참조값을 바라보고 있는지 확인해보기 위해서 두 방법으로 생성한 객체의 hashCode 의 값을 출력해보겠습니다.

기존 코드를 수정하여 출력함수에 hashCode 의 값을 출력하도록 하였습니다.


```
public void stringDataSame() {
        String data = "data";
        String data2 = "data";

        if (data == data2)
            System.out.println("result is same");
        else
            System.out.println("result is different");

        if (data.equals(data2))
            System.out.println("result is same");
        else
            System.out.println("result is different");

        System.out.println(data.hashCode() + " " + data2.hashCode());
    }

    public void stringNewDataSame() {
        String data = new String("data");
        String data2 = new String("data");

        if (data == data2)
            System.out.println("result is same");
        else
            System.out.println("result is different");

        if (data.equals(data2))
            System.out.println("result is same");
        else
            System.out.println("result is different");

        System.out.println(data.hashCode() + " " + data2.hashCode());
    }
```

<br>


출력되는 결과는 하기와 같습니다.

<br>

```
result is same
result is same
3076010 3076010
result is different
result is same
3076010 3076010
```


<br>

리터널 방식으로 생성한 변수가 아닌, String 객체를 생성한 변수도 같은 hashcode 를 가지고 있습니다. hashCode 메서드는 객체를 식별하는 하나의 정수값인데요, Object 의 hashCode 메서드는 객체의 메모리 번지를 이용해 해시코드를 만들어 리턴합니다. 때문에 객체마다 다른 값을 가지고 있어야 하는데요. 결과가 이상하지 않나요?

문자열 비교 연산자인 '==' 으로 비교를 하였을 때 분명 다르다는 결과가 출력이 되었는데, 왜 hashCode 값을 비교하니 동일한 해시코드를 가지고 있는 걸까요? 메서드 내에서 생성한 변수들 모두 다요.

이유는 String 클래스는 hashCode 주소값과 관련이 없습니다.
String 클래스는 Object 클래스의 hashCode 메서드를 그대로 사용하지 않고 재정의하였습니다. 그리고 오버라이딩 된 그 규칙에 따르면, 같은 문자열은 동일한 hashcode 값을 가지게 됩니다.

**String 클래스에서 재정의를 하지 않았더라면, String 클래스에서 hashcode는 서로 다른 값을 가져야 하겠죠?**

만일 같은 문자열을 갖는 두 객체의 hashcode 가 다르다면, hashcode는 의미가 없어집니다. hashcode 를 활용하여 Map 이나 Set 에 저장된 Key 값을 찾아야 하는데, 같은 객체임에도 불구하고 hashcode 값이 다르다면 제대로 찾을 수 없게 됩니다.

그러므로 인위적으로 String 클래스 내에서의 hashcode 메서드를 재정의하여 같은 String 객체에 대해 hashcode 가 같아지도록 만든 것이라고 합니다.


<br>
<br>

## 결론, 그리고 String 클래스에 관한 고찰
결론적으로는 literal 방식을 이용할 경우에는 다른 변수명을 가지고 있어도 데이터가 동일하면 메모리 주소값은 동일하게 됩니다. 때문에 '==' 비교 연산자로 비교를 하려고 한다면, String 객체를 어떻게 생성했느냐에 따라서 그 결과가 달라질 수도 있기 때문에 equals() 메서드를 이용하여 데이터 자체만을 비교하여야만 합니다. 또한 hashCode() 는 String 클래스에서 재정의가 되어 있기 때문에 데이터가 같다면 동일한 hashcode 를 가지고 있기 때문에 사용시 주의할 필요가 있을 것 같습니다.

다른 이야기지만, String 객체를 생성할 때 두 방법 중 literal 방식이 성능상 좋습니다.

이유는 String 클래스는 불변하다는 특징을 가지고 있는데, 데이터는 변경이 불가능합니다. 즉 문자열을 결합하게 되었을 때, 아래와 같이 두 문자열을 결합하기 위해선 새로운 메모리 공간을 할당을 받습니다. 문자열을 결합할 때마다 객체를 생성한다는 것입니다. 그리고 기존 객체는 GC의 대상이 됩니다.

가령 a 라는 변수에 "abc" 라는 문자열이 대입되어 있고, b 라는 변수에 "123" 이라는 문자열로 둔갑한 숫자로 이루어진 문자들이 있을 경우, 결합 연산을 하게되면 이들을 결합한 새로운 메모리 공간이 할당이 됩니다

a -> 0x123 ("abc")
b -> 0x456 ("123")
c -> 0x789 ("abc123") 두 객체를 결합하기 위한 새로운 객체가 생성 됌.

이처럼 문자열을 결합하면 매번 새로운 객체를 할당받는다는 문제점으로 인해 보완된 방법이 있는데, 이와 비슷한 논리로 매번 String 객체를 new 키워드로 생성한다면, 메모리의 낭비가 크지 않을까요?


<br>
<br>

## Reference
- 자바의 정석
- 자바의 신
- hashCode() String 클래스에서의 오버라이딩 - https://m.blog.naver.com/PostView.nhn?blogId=travelmaps&logNo=220930144030&proxyReferer=https:%2F%2Fwww.google.com%2F


