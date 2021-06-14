


## JVM 이란 무엇일까?

- **JVM이란 Java Virtual Machine 의 줄임말로, Java Byte Code 를 운영체제에 맞게 해석해주는 역할**을 합니다. 즉, 작성한 자바 프로그램의 실행 환경을 제공하는 자바 프로그램의 구동 엔진입니다.
- Java compiler 는 .java 파일을 .class 라는 자바 바이트코드로 변환시켜주는데 Byte Code 는 기계어(Native Code)가 아니므로 OS 에서 바로 실행이 되지 않습니다. 이때 JVM은 OS가 Byte Code 를 이해할 수 있도록 해석해주는 역할을 담당합니다.
- **JVM은 메모리 관리도 담당**합니다. 이를 **'가비지 컬렉터'라고 하는데, 가비지 컬렉터는 Java7부터 힙 영역의 객체들을 관리하는 역할을 담당**합니다.

<br>

## JVM 의 중요성

- **동일한 기능을 하는 프로그램**이더라도 **메모리 관리에 따라 성능이 좌우**될 수 있습니다.
- 메모리가 관리 되지 않을 경우 속도 저하나 프로그램의 중단 및 시스템의 부하 및 장애 등으로 발생할 가능성이 있습니다. → 당연히 서비스에도 장애가 발생할 수밖에 없습니다.
- **한정된 메모리를 효율적으로 사용하여 최고의 성능**을 끌어낼 수 있습니다.

<br>

## JVM은 힙을 세 개의 영역으로 나누어 관리한다

**Java의 GC, 가비지 컬렉터**

![](https://images.velog.io/images/pearl0725/post/13875c20-35c9-4001-9660-6698eabf99a8/image.png)

- **New/Young Generation** : 새로 생성된 객체를 저장합니다. → 객체가 힙에 최초로 할당이 되는 장소라는 의미입니다.
    - **Oracle JVM 에서는 새로 생성되었거나, 생성된 지 얼마 되지 않은 객체는 Eden 영역에 저장**이 됩니다. Eden 영역에 일정 수준 이상으로 사용률을 보이면 가비지 컬렉션이 발생하여 객체의 참조 여부를 따져 참조가 되어 있는 사용중인 객체라면 Survivor 영역으로 이동하고, **참조가 끊어진 Garbage 객체라면 남겨놓은 후, 사용중인 객체들이 모두 Surivor 영역으로 넘어가면 Eden 영역을 모두 청소**합니다.
    - Young Generation 의 Survivor 영역은 Eden 영역에서 청소되지 않은 객체들이 할당받은 공간인데, 이 Survivor 영역은 두 개로 구성이 됩니다. 이것을 Minor GC 라고 칭한다고 합니다.
        - 왜 Survivor 영역은 두 개로 구성이 될까요? 하나의 Survivor 영역이 차게 되면, 다른 영역으로 복사가 됩니다. 이때 Eden 영역에 있던 살아남은 객체들은 다른 Survivor 객체로 넘어갑니다. → 즉, 둘 중 하나는 반드시 비어 있어야만 합니다.
        
      <br>
        
- **Old Generation** : 만들어진지 오래된 객체를 저장합니다. → Survivor 영역에서 살아있는 객체로 오래 남아 있던 객체는 Old Generation 으로 이동하게 됩니다. ***특정 회수 이상 참조가 되어 기준 Age를 초과한 객체를 의미합니다.**
    - 어떻게 설정을 하였느냐에 따라 다르지만, 오래 생성되어 있어야 하는 객체는 가비지 컬렉션을 거치면서 Old 영역으로 이동을 하게 됩니다.
    - 즉, 비교적 오랫동안 참조가 되어 이용되고 있고 앞으로도 지속적으로 사용할 확률이 높은 객체들을 저장하는 영역입니다.
    - **Old Generation의 메모리도 충분하지 않으면, 해당 영역에도 GC가 발생**하는데 이를 Full GC(Major GC)라고 합니다.
    
     <br>
     
- **Permanent Generation** : JVM 클래스와 메서드 객체를 저장합니다.
    - **JDK8 부터는 해당 Heap 영역이 제거**가 되었다고 합니다. 이 친구는 JVM에 의해 크기가 강제되던 영역이었는데, 대신에 **Metaspace 영역이 추가가 되었고 해당 영역은 OS가 자동으로 크기를 조절**합니다. → OS 레벨에서 관리되는 영역, Metaspace가 Native 메모리를 이용함으로써 개발자는 영역 확보의 상한을 크게 의식할 필요가 없어지게 되었다고 합니다. **(기존에는 힙 영역 외에 Perm 영역을 별도로 튜닝을 하였다고 합니다.) Java8 부터는 튜닝 옵션을 주어 성능 튜닝을 한다고 하는데, 추후에 싱글 쓰레드와 멀티 쓰레드를 공부하게 되면 해당 부분은 꼭 공부해보고 싶다는 생각이 되네요!**
    
    <br>
    
    
**- Java7 HotSpot JVM의 구조**
![](https://images.velog.io/images/pearl0725/post/f08f8b59-d074-4190-aab5-8173b1d5dbab/image.png) 

                           
**- Java8 HotSpot JVM의 구조**
![](https://images.velog.io/images/pearl0725/post/a00063d3-e876-4b50-b767-ab434fdb90eb/image.png)

                              
 <br>
 

## Young Generation GC 와 Old Generation GC 누가 더 빠를까?

- Young Generation GC가 더 빠르다. 이유는 일반적으로 더 작은 공간이 할당되고, 객체를 처리하는 방식도 다르기 때문입니다. 





<br>

## GC 의 역할은 무엇일까?

- 어떠한 객체를 생성하였을 때, 이 객체를 사용하기 위해 메모리에 적재가 됩니다. 사용이 완료된 후 할당받은 메모리 공간을 비워주지 않으면 불필요한 메모리 공간이 누적이 되어 자바 프로그램이 많은 메모리 사용률을 보이게 되면서 서버에서 실행중인 프로그램이 정상 동작하지 않거나, 중단이 되는 현상이 발생할 수도 있는데, 자바에서는 가비지 컬렉터라는 것이 동적으로 공간을 정리해줍니다.
- 일부 관리되지 않는 외부 리소스(unmanaged resource)는 수동으로 메모리 해제를 하여야 합니다.
- C언어 같은 경우에는 동적 메모리 할당을 통해 힙 영역의 데이터를 읽고 쓰는데, 사용자가 직접 동적 메모리 할당을 해제하여야 하는 어려움이 있다고 합니다. (malloc)
- JAVA는 힙 영역의 메모리 관리를 사용자가 하지 않고 GC가 처리합니다.

<br>

## 자바 소스가 컴파일이 되는 순서는?

1. Java 언어로 작성한 코드(.java)를 Build 라는 작업을 하게 되면 Java Complier의 명령어를 통해 .class 파일을 생성하게 됩니다.
2. 해당 코드는 바이트코드(.class)로 변환되어 파일이 만들어집니다.
3. 이 파일은 JVM을 거쳐서 기계어 코드 파일로 변환이 됩니다.

<br>

## JVM 에서 실행 가능한 코드, '한 번 작성하면 어디에서나 실행'이라는 장점의 핵심인 바이트 코드와 Execution Engine

- Java 소스를 컴파일한 결과물이며, 확장자는 .class 으로 클래스 파일이라고도 합니다.
- 이 바이트 코드 파일이 어떠한 운영체제에서도 실행이 가능하도록 합니다. 이는 특정 운영체제가 이해할 수 있는 기계어가 아니며, JVM이 이해할 수 있는 명령어입니다. → JVM이 설치되어 있지 않다면 실행할 수 없다는 단점이 있습니다.

![](https://images.velog.io/images/pearl0725/post/0447372b-a7ab-49bf-8042-fee0fd90ac6c/image.png)


**Execution Engine 컴파일 방식과 구성요소**

- **Interpreter 방식**
    - **바이트 코드를 한 줄씩 해석하고 실행**하는 방식입니다. 초기의 방식으로 성능이 매우 느리다는 단점이 있었습니다.
- **static 정적 컴파일 방식**
    - 실행하기 전에 컴퓨터가 이해할 수 있는 언어인 Native Code 로 변환하는 작업을 수행합니다.
- **JIT(Just In Time) 컴파일 방식 (= Interpreter + Static Compile)**
    - 기존의 인터프리터 방식의 문제점을 보완한 것이 JIT 컴파일 방식입니다. 바이트 코드를 **JIT 컴파일러를 이용하여 프로그램을 실행하는 시점에 각 Native Code(직접 CPU에서 동작할 수 있는 코드)로 변환**하여 실행 속도를 개선하였다고 합니다. → 바이트코드를 Native Code로 변환하는 데에도 비용이 소요(JVM을 처음 구동을 하게 되면, 수천 개의 메소드가 호출이 됌..)되므로, JVM은 모든 코드를 JIT 컴파일러 방식으로 실행하는 것이 아닌, 인터프리터 방식으로 사용하다가 일정 기준이 넘어가면 JIT 컴파일 방식으로 명령어를 실행합니다.
    - **JIT 컴파일러는 같은 코드를 매번 해석하는 것이 아닌, 실행할 때에 컴파일을 하면서 해당 코드를 캐싱**한다는 장점이 있습니다. **이후에는 변경이 된 부분만 컴파일을 하고, 나머지는 캐싱된 코드를 사용**합니다.
- **GC(Garbage Collector)**

![](https://images.velog.io/images/pearl0725/post/1556edae-0525-4b66-9713-b7e3f67c4447/image.png)


<br>

## 타 프로그래밍 언어와 Java 프로그래밍 언어 비교

- 타 프로그래밍 언어로 짜여진 프로그램은 프로그램이 실행되기 위해선 OS가 제어하고 있는 RAM 을 제어할 수 있어야 합니다. **C언어와 같은 프로그램은 OS 에 종속되어 실행**이 됩니다.
- 자바 프로그램은 JVM이 있으면 실행이 가능합니다. OS가 JVM에게 메모리의 사용 권한을 넘기고, JVM이 자바 프로그램을 호출하여 실행합니다. 때문에 자바 프로그램은 OS가 아닌 JVM에 종속적이게 됩니다. → 프로그램이 **OS가 아닌 JVM에 종속적이기 때문에 플랫폼에 독립적인 이유**가 됩니다. 어떤 OS 에서도 JVM만 설치가 되어 있으면 프로그램을 읽을 수 있다는 장점이 있습니다.

![](https://images.velog.io/images/pearl0725/post/455a51c9-9de5-4466-bf94-066497b66466/image.png)

                              

<br>

## 어떻게 운영체제와 별개로 동작하는 걸까?

- 하기의 그림은 JDK를 설치하기 위한 자바 리포지터리입니다. JDK를 설치하기 위해서는 각 운영체제마다 JDK가 다른 것을 확인해볼 수 있는데요, 이 JDK 패키지 내에는 JRE, API 를 포함하여 JVM 도 설치가 됩니다. 운영체제마다 다른 JVM이 제공되기 때문에 별개의 패키지를 설치하여 작동하여야 합니다.

![](https://images.velog.io/images/pearl0725/post/90d0dac2-61a6-4033-8b2e-688f030ce3e7/image.png)

<br>

## JDK와 JRE 차이는 무엇일까?

- JDK는 JRE(Java Runtime Environment) + Development Kit 으로 구성이 되어 있으며, JRE는 JVM(Java Virtual Machine) + Library 로 이루어져 있습니다. 자바를 사용하기 위해서는 JDK 설치는 필수입니다.
- **JRE(Java Runtime Environment)**
    - 자바 런타임 환경은 JVM에서 실행하기 위한 자바 애플리케이션을 실행할 수 있도록 구성되어 있습니다. JRE는 Java Development Kit 를 다운로드 할 때에 포함이 되어 있습니다.
- **JDK(JRE + Development Kit)**
    - 자바 애플리케이션을 구축하기 위한 플랫폼 구성 요소입니다.
    
    <br>

## 결론, JVM 도대체 어떻게 구성이 되어 있는 거야!

- **Class Loader**
    - .class(byte code)들을 실제 메모리에 적재하는 역할을 합니다.
    - WAS 마다 Class Loading 방식에 조금씩 차이가 있다고 하네요! 상세 내용은 하기의 자료를 참고하면 좋을 것 같습니다. 추후에 어느정도 공부가 되면 이 자료를 참고해서 공부를 해야겠습니다.
        - [https://www.kdata.or.kr/info/info_04_view.html?dbnum=183810](https://www.kdata.or.kr/info/info_04_view.html?dbnum=183810)
- **Execution Engine**
    - 바이트 코드를 읽고 CPU가 해석 가능한 기계어로 번역하여 실행하는 역할을 합니다.
- **Runtime Data Area(Memory)**
    - jvm 메모리와 관련된 부분으로, 5가지 영역으로 나뉩니다.
    - Method Area (=Class Area, Code Area, Static Area)
    - Heap Area
    - Stack Area
    - PC registers
    - Native Method stack
- **Native**
    - Java 에서 C, C++, Assembly 로 작성된 API 를 사용할 수 있도록 해주는 역할을 합니다.
    

<br>


## 추후에 읽어보면 좋을만한 자료!

**Class Loader**
   - [https://www.kdata.or.kr/info/info_04_view.html?dbnum=183810](https://www.kdata.or.kr/info/info_04_view.html?dbnum=183810)
    
**JIT**
   - [https://aboullaite.me/understanding-jit-compiler-just-in-time-compiler/](https://aboullaite.me/understanding-jit-compiler-just-in-time-compiler/) 

