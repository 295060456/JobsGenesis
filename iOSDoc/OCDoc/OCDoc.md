# OC相关经验
[toc]
## <span style="color:red; font-weight:bold;">***OC/C.Block***</span>
* ***Block* 的捕获变量：** 当一个 *Block* 被创建时，它会捕获在其内部使用的外部变量。  
  
  * **对于局部变量，*Block* 会在创建时将其复制一份，然后在 *Block* 内部使用。**如果 *Block* 在定义时没有修改该变量，那么这个变量的值在 *Block* 内部是不可变的。这被称为值捕获（*Value Capture*），捕获的变量可以是局部变量或全局变量；
  ```objective-c
  // 定义一个Block
  typedef void (^SimpleBlock)(void);
  
  int main() {
      // 定义一个局部变量
      __block int count = 0;
      // 定义一个Block，并在Block内部使用count变量
      SimpleBlock block = ^{
          NSLog(@"Count inside block: %d", count);
      };
      // 修改count的值
      count = 10;
      // 调用Block
      block(); // 这里的count值在Block内部被捕获，即使count在Block定义之后被修改，但值仍然被捕获
      return 0;
  }
  // 输出将会是：
  Count inside block: 10
  
  /**
  在这个例子中，Block捕获了count变量的值，即使在Block定义之后count的值被修改，Block内部仍然使用了最初捕获的值。
  */
  ```
  * **对于全局变量，*Block* 会直接引用其内存地址，而不会复制**；
* **`__block` 修饰符**
  * 当需要在 *Block* 内部修改局部变量的值时，需要使用 `__block` 修饰符来声明该变量。这样，在 *Block* 内部就可以通过引用来修改外部变量的值；
  * <span style="color:red; font-weight:bold;">***使用 `__block` 修饰的变量在 Block 内部会被包装为一个结构体，这个结构体中包含了一个指向原始变量的指针。这样 Block 内部就可以通过这个指针来修改变量的值，而不会影响到原始变量的值；***</span>
* ❤️**Block 的存储**
  * *Block* 是一个**对象**，它在***[堆](# 堆(Heap))上分配***内存；
  * 当一个 *Block* 捕获了一个 `__block` 修饰的变量时，*Block* 不会直接捕获这个变量的值，而是**捕获了一个指向变量的指针**；
  * 当 *Block* 在创建时，会检查其所引用的外部变量，如果有被 `__block` 修饰的变量， *Block*将这些变量的地址包装到一个结构体中，然后将这个结构体的指针传递给 *Block*；
## OC里面有没有类似于Java里面的`linkedhashset`的东西

* 在Objective-C中，没有直接类似于Java中*LinkedHashSet*的数据结构；
* 但是，你可以使用*NSOrderedSet*，它是一个有序不可变集合，保留了元素的插入顺序；
* 如果你需要可变版本，可以使用*NSMutableOrderedSet*。这不同于*LinkedHashSet*，但提供了一种有序且不包含重复元素的选择；

## 可能会存在属性没有对应的 `getter` 和 `setter` 方法的情况

* 一个例子是使用 `@dynamic` 关键字来声明属性。在使用 Core Data 框架或者实现了自定义的动态属性存取方法时，你可能会使用 `@dynamic` 来告诉编译器，该属性的 `getter` 和 `setter` 方法由运行时或其他方式动态生成，而不是在编译时静态声明。
* 另一个例子是在 Objective-C 中使用关联对象（Associated Objects）。关联对象允许你向已有的类中添加属性，而无需修改类的源代码。这种情况下，你可能不会显式地声明属性的 getter 和 setter 方法，而是通过关联对象来存取属性值。

## ***OC.AssociatedObjects（关联对象）***

* 允许你向已有的类中添加属性，而无需修改类的源代码；
* 依赖于 Objective-C 运行时机制；
* 可以动态地将一个对象与一个 key 关联起来，然后可以在运行时根据这个 key 来获取或设置关联的对象；
* 关联对象***不会影响类的继承体系***，也***不会改变类的实例变量***，而是将额外的数据***存储在一个全局的关联表***中；
  * 导入 `<objc/runtime.h>` 头文件；
  * 创建一个 key，作为关联对象的唯一标识符。这个 key 是一个静态变量，通常是一个唯一的地址，你可以使用 `static` 关键字来定义；
  * 使用 `objc_setAssociatedObject` 函数将对象与 key 关联起来，并设置关联的策略（如 `OBJC_ASSOCIATION_RETAIN` 或 `OBJC_ASSOCIATION_ASSIGN`）以及要关联的对象；
  * 使用 `objc_getAssociatedObject` 函数根据 key 获取关联的对象；
  * 如果需要，使用 `objc_removeAssociatedObjects` 函数来移除与对象相关的所有关联对象；

***如何使用关联对象为一个类添加一个动态属性：***

```objective-c
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface MyClass : NSObject
@end

@implementation MyClass
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建一个 key 作为关联对象的标识符
        static void *MyKey = &MyKey;
        
        // 创建一个 MyClass 的实例
        MyClass *myObject = [[MyClass alloc] init];
        
        // 设置关联对象
        NSString *associatedObject = @"Associated String";
        objc_setAssociatedObject(myObject, MyKey, associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // 获取关联对象
        NSString *retrievedObject = objc_getAssociatedObject(myObject, MyKey);
        NSLog(@"Associated Object: %@", retrievedObject); // 输出：Associated Object: Associated String
    }return 0;
}
/**
  在这个例子中，我们向 MyClass 类的实例添加了一个动态属性，该属性与一个字符串对象关联;
  我们使用 objc_setAssociatedObject 函数将字符串对象与 MyClass 实例关联起来;
  并使用 objc_getAssociatedObject 函数来获取关联的对象。
*/
```

## KVC 和 KVO

### KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储**

* 通过key->对象属性。不需要通过`set/get`方法；
* 对于支持 KVC 的对象，可以通过 `setValue:forKey:` 和 `valueForKey:` 等方法来设置和获取属性值；
* KVC 在实现**数据绑定**、**序列化**和其他一些需要**动态地访问属性**的场景中非常有用；
* 也有一些特殊情况下的对象不支持 KVC。例如：
  * 未定义键的属性：如果[***一个属性没有对应的 `getter` 和 `setter` 方法***](# 可能会存在属性没有对应的 `getter` 和 `setter` 方法的情况)，或者不符合 KVC 的命名规范，那么该属性就不支持 KVC。

### KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察**

* KVO 是一种**观察者模式**的实现，它**允许一个对象（非类）监听另一个对象的属性的变化**；
* 不是所有的类都支持KVO：
  * ***类必须直接或间接地继承自NSObject（即，类必须实例为对象）***：这是因为KVO是基于Objective-C runtime系统的，它利用了Objective-C的动态特性来观察对象属性的变化；一个常见的反例是 Core Graphics（Quartz）框架中的许多类型，如 CGPoint、CGSize、CGRect 等。这些类型是 C 语言结构体，而不是 Objective-C 对象，因此它们不继承自 NSObject，并且不支持 KVO。
  * ***被观察的属性必须是对象的属性，而非标量类型***（例如int、float等）；
  * ***被观察的属性必须使用属性访问器方法***（通常是getter和setter方法），***而不是直接访问实例变量***；
* 当被监听对象的某个属性发生变化时，注册了观察者的对象会收到通知，从而可以采取相应的操作；
* KVO的使用步骤：
  * 先注册观察者
  * 实现相应的观察方法
  * 当被观察的属性值变化时，观察者对象的观察方法会被调用
* 对于 KVO 来说，被观察的属性必须符合一定的**命名规范**，通常以 `@property` 定义的属性都可以被观察；
```
1、KVO 和 KVC 在实际开发中经常一起结合使用，以实现对对象属性的动态访问和监听；
2、这两个特性能够使得代码更加灵活，同时也方便了数据模型和视图之间的通信；
3、在实际应用中，需要注意使用 KVO 和 KVC 时的内存管理和性能问题，以确保应用的稳定性和性能优化；
```
### KVO相应的观察方法
**`observeValueForKeyPath:ofObject:change:context:`**
- 这是 [***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察) 观察者对象必须实现的方法之一；
- 当被观察对象的属性值发生变化时，系统会调用这个方法，并传递一些参数，包括被观察的属性的键路径、被观察的对象、属性的改变信息以及上下文信息；
- 观察者对象在实现这个方法时，可以根据传递的信息执行相应的操作，比如更新 UI、处理数据等；
- 观察者对象应该在不需要监听属性变化时取消观察，以防止悬挂指针或野指针的问题；
  * 在观察者对象的 `dealloc` 方法中，需要调用 `removeObserver:forKeyPath:` 或 `removeObserver:forKeyPath:context:` 方法来移除观察者
```objective-c
#import <Foundation/Foundation.h>

@interface MyObject : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation MyObject
@end

@interface Observer : NSObject
@end

@implementation Observer
- (instancetype)init {
    if (self = [super init]) {
        MyObject *obj = MyObject.new;
        // 添加观察者
        [obj addObserver:self 
              forKeyPath:@"name"
                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        // 修改属性值
        obj.name = @"New Name";
    }return self;
}
// 实现观察者的回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NS
```
### KVC 和 KVO的相互调用问题

#### <span style="color:red; font-weight:bold;">***在使用KVC的时候会使用的KVO吗？***</span>

* 虽然在使用 [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储)时不会直接用到 [***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察) ，但是它们通常会**结合使用**。特别是在设计模式中的 MVC（Model-View-Controller）中：
  * Model 层通常会**负责存储应用程序的数据**，并且可能会实现 [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储)，以便其他部分可以通过键路径来访问和修改这些数据；
  * 而 View 层通常**负责显示数据**，并且可能会观察（通过  [***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察) ）Model 层的一些属性，以便在数据发生变化时更新界面；
  * Controller 层则充当了**数据的处理和业务逻辑的中介**；
* 在这种情况下，当 Model 层的属性通过 [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储) 进行更改时，View 层可能会通过  [***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察)  接收到通知，并相应地更新界面。因此，尽管在直接的语法上并不会在使用 KVC 时调用  [***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察)  的方法，但在应用程序的整体架构中，它们往往是相辅相成的；

#### <span style="color:red; font-weight:bold;">***在使用KVO的时候会使用的KVC吗？***</span>

* 在使用[***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察) 时，通常不会直接使用 [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储)，因为**它们是两个独立的特性**。然而，在某些情况下，它们**可能会间接地结合使用**；
  * **注册观察者时的键路径**： 在注册观察者时，需要提供要观察的属性的键路径。这个键路径通常是通过 [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储) 的方式指定的，因为它需要准确地指定被观察属性的路径;
  ```objective-c
  [object addObserver:self 
          forKeyPath:@"propertyName" 
          options:NSKeyValueObservingOptionNew 
          context:nil];
  ```
  * **观察者获取属性值**： 在观察者对象中，当收到属性变化的通知时，可能会使用  [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储) 来获取被观察对象的属性值;
  ```objective-c
  - (void)observeValueForKeyPath:(NSString *)keyPath
          ofObject:(id)object 
          change:(NSDictionary *)change 
          context:(void *)context {
      if ([keyPath isEqualToString:@"propertyName"]) {
          id newValue = [object valueForKey:@"propertyName"];
          // 处理属性变化后的操作
      }
  }
  ```
    虽然**在实现** [***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察)  **时可能会涉及到使用**  [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储)  **来指定属性路径和获取属性值**，但是它们本质上是两个不同的概念。 [***KVO***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察)  是一种观察者模式，用于监听对象属性的变化，而 [***KVC***](# KVC（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***C***</span>oding）：**键值存储) 则是<u>一种机制</u>，用于通过键（key）来访问对象的属性。
## MVP

* MVP（**M**odel-**V**iew-**P**resenter）模式是一种软件架构模式，用于设计和组织用户界面（UI）代码；
* 它是**基于MVC**（**M**odel-**V**iew-**C**ontroller）模式的变种，***旨在解决 MVC 模式中 Controller 过于臃肿和难以测试的问题***；
* 在 MVP 模式中，UI 层被分为三个主要组件：
  * **Model（模型）**：Model 表示应用程序的数据和业务逻辑。它独立于 UI 和 Presenter，并**负责处理数据的获取、存储和处理**；
  * **View（视图）**：View 是用户界面的可视化部分，负责呈现数据给用户并接收用户的输入操作。View 应该尽量减少业务逻辑，并且**只负责 UI 的展示**；
  * **Presenter（呈现者）**：Presenter 充当了*** View 和 Model 之间的中介***，负责协调用户界面和数据之间的交互。它接收来自 View 的用户输入，并根据需要更新 Model。同时，它也监听 Model 的变化，并相应地更新 View。**Presenter 通常包含了大部分业务逻辑**；
* MVP 模式的主要思想是***将 UI 逻辑从 View 中抽离出来，并将其交给 Presenter 处理***；
  * 这样可以使得 UI 更加简洁；
  * 可测试性更强；
  * 同时也降低了代码的耦合度，使得代码更易于维护和扩展；
* MVP 缺点：
  * **视图和 Presenter 之间的绑定**：视图和 Presenter 之间的交互通常需要通过接口或回调来实现，这会增加一些额外的代码和复杂性；
  * **繁琐**：相比于 MVVM，MVP 中需要手动进行数据绑定，因此可能会显得更加繁琐；
## MVP vs MVVM
````
MVP（Model-View-Presenter）和 MVVM（Model-View-ViewModel）都是常见的软件架构模式，用于设计和组织用户界面（UI）代码。
它们各有优缺点，适用于不同的项目和场景，没有绝对的优劣之分，取决于项目需求和团队偏好。
````
* ***MVP的优点***
  * **清晰分离**：MVP 将用户界面、业务逻辑和数据分离得很清晰，每个组件的职责明确，易于理解和维护；
  * **测试容易**：Presenter 包含了大部分业务逻辑，因此很容易进行单元测试，而且可以独立于 UI 进行测试；
  * **灵活性**：MVP 可以很容易地在不同平台上重用业务逻辑，因为它们与特定的 UI 框架无关；
* ***MVP的缺点***
  * **视图和 Presenter 之间的绑定**：视图和 Presenter 之间的交互通常需要通过接口或回调来实现，这会增加一些额外的代码和复杂性；
  * **繁琐**：相比于 MVVM，MVP 中需要手动进行数据绑定，因此可能会显得更加繁琐；
* ***MVVM的优点***
  * **双向数据绑定**：MVVM 提供了**双向数据绑定**，当数据模型变化时，视图会自动更新，反之亦然，减少了手动更新视图的工作量；
  * **简化视图代码**：由于数据绑定的存在，视图中通常不需要包含大量的逻辑，使得视图代码更加简洁；
  * **可测试性**：ViewModel 中的业务逻辑可以很容易地进行单元测试，因为它们不依赖于 UI 框架；
* ***MVVM的缺点***
  * **学习曲线**：MVVM 模式相对于 MVP 来说，对于新手可能会有一定的学习曲线，尤其是在理解和使用数据绑定的概念上；
  * **框架依赖**：MVVM 通常依赖于特定的框架或库来实现数据绑定，因此可能会增加项目的依赖性。
```
MVP 适合需要更加灵活和可测试的项目，而 MVVM 则适合需要简化视图代码和数据绑定的项目
```
## 字符是由ASCII码一一对应的。那么在内存里面，是如何与整型（Int）进行区分的？
* 在内存中，字符和整数（包括 ASCII 码对应的整数）在**存储和表示上通常是不同的**；
* 在计算机中，每个数据类型都有一定的存储大小和表示方式；
  * **字符 (Character):** 在许多编程语言中，字符通常是使用 Unicode 编码表示的。在Swift中，字符类型是 `Character`，它使用 Unicode 标量来表示字符。Unicode 标量是一个唯一的整数值，用于表示字符在 Unicode 编码中的位置；
  * **整数 (Integer):** 整数是表示整数数字的数据类型。在Swift中，整数类型包括 `Int`、`UInt`、`Int8`、`Int16`、`Int32`、`Int64` 等，它们有不同的大小和符号性质；
* ASCII 码是一种字符编码方案，其中每个字符都被映射到一个整数值。ASCII 码通常使用 `Int` 或其等效的整数类型来表示；
* 在内存中，这两者的存储方式是不同的。***字符通常需要更多的存储空间，因为它们可能涉及 Unicode 编码和支持更广泛的字符集***；
*以下是一个简单的Swift示例，演示了字符和整数在内存中的不同表示：*
```swift
let char: Character = "A"
let asciiValue = char.asciiValue  // 获取字符的ASCII码

let integer: Int = 65  // 整数表示ASCII码

print("Character '\(char)' 在内存中的表示为: \(MemoryLayout.size(ofValue: char)) 字节")
print("整数 \(integer) 在内存中的表示为: \(MemoryLayout.size(ofValue: integer)) 字节")
```
请注意，这只是一个简单的示例，实际上内存中的表示和存储还涉及到字节顺序、对齐等因素，具体取决于编程语言和编译器的实现。
## ASCII码在内存里是用数字表示，但如果一个纯数字在内存怎么表示呢？会不会和ASCII码冲突？
* ASCII码是一种将字符映射到数字的编码方式，而数字本身在内存中以二进制形式表示；
* ASCII码通常用一个字节（8位）来表示，而纯数字也是以二进制形式存储；
* 在内存中，ASCII码和纯数字是以不同的二进制序列表示的，因此它们不会冲突；
## 结构体
* 在大多数编程语言中，结构体的成员会按照声明的顺序依次存储在内存中，这使得结构体的**内存布局是连续的**；
* 结构体通常存放在程序的**数据区域**，这包括栈内存或堆内存，具体取决于结构体是通过值传递还是引用传递；
  * 如果结构体是通过**值传递**，它通常会存储在**调用栈**上；
  * 而如果通过**引用传递**，它可能存储在**堆**上，并且引用传递时通常使用指针；
* 结构体的数据对齐是编译器为了提高存储和访问效率而进行的一种优化；
  * 在结构体中，各个成员的内存对齐**可能会受到硬件架构和编译器的影响**；
  * 一般而言，编译器会***尽量使结构体的起始地址是其最大基本数据类型成员大小的整数倍***
  ```c
  struct Example {
      char a;    // 1字节
      int b;     // 4字节
      double c;  // 8字节
  };
  在这个例子中，编译器可能会在char a后面填充3字节，使得int b从4字节对齐，double c从8字节对齐。这有助于提高结构体在内存中的访问效率。
  可以使用编译器特定的指令或者预处理器指令（例如#pragma pack）来改变结构体的对齐方式，但这样的改变可能会影响性能。
  通常情况下，由编译器自动进行的数据对齐足够满足大多数情况的需求。
  ```
## 雪花算法（Snowflake）
* 雪花算法（Snowflake）是一种分布式唯一ID生成算法；
* 最初**由Twitter开发**用于**生成全局唯一的ID**；
* 它的设计目标是在分布式系统中生成趋势递增且具有唯一性的ID，以便于在分布式环境下准确地排序和定位数据；
* 雪花算法的核心思想是***将64位的ID按照一定规则进行拆分，使得每一部分都可以确保唯一性和递增性，从而保证生成的ID在分布式环境中不会发生冲突，并且能够按照时间顺序进行排序***；
* 雪花算法（Snowflake）算法的ID通常包含以下几个部分：
  * **时间戳（Timestamp）**：占用了64位中的一部分，通常是毫秒级的时间戳，可以精确到毫秒级别；
  * **机器ID**：用来标识不同的机器，确保不同机器生成的ID不会发生冲突。在一些实现中，这个部分通常包括了数据中心ID和机器ID；
  * **序列号（Sequence Number）**：用来解决同一毫秒内生成多个ID时的冲突问题。序列号占用了一定的位数，可以确保在同一毫秒内生成的ID在机器ID相同的情况下是唯一的；
* 10位的机器ID可以表示的不同节点数量为2的10次方，即1024。因此，在雪花算法中，**系统可以容纳最多1024个不同的节点（机器）**，每个节点都被分配一个唯一的10位机器ID。这确保了在同一时间内，最多有1024个不同的节点可以生成唯一的ID，防止ID冲突；
## 计算机内存是怎么去表示浮点数的
* 计算机内存使用**IEEE 754标准**来表示浮点数；
* 这标准规定了浮点数的存储方式，包括单精度（32位）和双精度（64位）两种格式；
  * 单精度浮点数的结构存储为：1位符号位 + 8位指数部分 + 23位尾数部分
  * 双精度浮点数的存储结构为：1位符号位 + 11位指数部分 + 52位尾数部分
  * 这种存储方式允许计算机在有限的内存中表示广泛的浮点数值，并提供了一种平衡精度和存储空间的方法；
* 浮点数通常由三部分组成：符号位、指数部分和尾数部分；
  * 符号位表示正负；
  * 指数部分用于表示数的大小；
  * 尾数部分则包含数值的有效数字；
## IPv6
* IPv6地址空间更大，为128位，这使得有更多的地址组合。
* IPv6中的端口号仍然是16位，因此有2^16（65536）个可能的端口号。
* 与IPv4不同的是，**IPv6不需要像IPv4一样分出专门的私有地址范围**，因为IPv6的地址空间足够大，**允许每个设备都有一个全局唯一的地址**。
* 总的IPv6地址-端口对数目：2<sup>128</sup> x 2<sup>16</sup> = 2<sup>144 **这是IPv6网络中可能的唯一的地址-端口对的总数**
**与IPv4相比，IPv6具有更大的地址空间和端口数目，而且IPv6中没有像IPv4那样需要特别保留的地址范围，因此它实际上提供了更多的灵活性。**
## 一个IP能有多少个端口
* 每个IPv4地址有**65535**个端口，而每个IPv6地址有2^16次方（约**65,536**）个端口；
  * 0到1023是***系统保留端口***；
  * 1024到49151是***注册端口***；
  * 49152到65535是***动态或私有端口***；
* 端口的使用是通过网络协议来管理的，典型的例子是TCP和UDP；
## int *p = &a
* 这行代码是在C或C++中声明了一个整数指针变量 `p`，并将其初始化为变量 `a` 的地址；
* `&a` 表示取变量 `a` 的地址，然后将这个地址赋给指针变量 `p`；
* 这样，`p` 就指向了变量 `a` 的位置，可以通过 `p` 来访问和操作变量 `a`；
* `int *p` 表示 `p` 是一个整数指针，可以用来存储整数变量的地址；
* 整数指针是指一个指针，其目标是整数类型的变量
## <span style="color:red; font-weight:bold;">***OC和JS交互***</span>

* 通常情况下是通过**字符串**进行交流
* **JavaScriptCore 框架:**允许在 *OC* 或 *Swift* 代码中执行 *JavaScript* 代码，**并且还可以在 *JavaScript* 和 *OC/Swift*之间进行对象的相互转换。**
```objective-c
// 引入 JavaScriptCore 框架
#import <JavaScriptCore/JavaScriptCore.h>
// 创建一个 JavaScriptContext 对象
JSContext *context = JSContext.new;
// 定义 JavaScript 函数
NSString *jsCode = @"function add(x, y) { return x + y; }";
[context evaluateScript:jsCode];
// 调用 JavaScript 函数
JSValue *addFunction = context[@"add"];
JSValue *result = [addFunction callWithArguments:@[@10, @20]];
// 获取结果
NSInteger sum = [result toInt32];
NSLog(@"Sum: %ld", (long)sum); // 输出: Sum: 30
```
* **WKScriptMessageHandler**
```objective-c
// ViewController.m

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建 WKWebView
    WKWebViewConfiguration *configuration = WKWebViewConfiguration.new;
    // 添加消息处理程序
    [configuration.userContentController addScriptMessageHandler:self name:@"myHandler"];
    
    self.webView = [WKWebView.alloc initWithFrame:self.view.bounds configuration:configuration];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    NSString *htmlPath = [NSBundle.mainBundle pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    [self.webView loadHTMLString:htmlString baseURL:nil];
  
    // OC 调用 JS
    [self.webView.configuration.userContentController addScriptMessageHandler:self // 消息处理程序对象，一般是遵循 WKScriptMessageHandler 协议的 Objective-C 对象
                         																							   name:@"myHandler"];// 消息的名称或标识符，用于区分不同类型的消息
}
// JS 调用 OC
- (void)userContentController:(WKUserContentController *)userContentController 
      didReceiveScriptMessage:(WKScriptMessage *)message{
        
    NSString *messageBody = (NSString *)message.body;
    NSLog(@"Received message from JavaScript: %@", messageBody);
    // 在这里处理 JavaScript 发送过来的消息
}

@end
```
```html
<!-- index.html -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaScript Objective-C Interactions</title>
</head>
<body>
    <h1>JavaScript Objective-C Interactions</h1>
    
    <button onclick="sendMessageToObjC()">Send Message to Objective-C</button>
    
    <script>
        function sendMessageToObjC() {
            var message = "Hello from JavaScript!";
            window.webkit.messageHandlers.myHandler.postMessage(message);// 关键代码：向 Objective-C 发送消息
        }
    </script>
</body>
</html>
```
## ***OC.依赖注入***

<span style="color:red; font-weight:bold;">***在 Objective-C 中，虽然没有像一些现代语言（如Java、C#、Swift等）中那样内置的依赖注入容器，但仍然可以手动实现依赖注入模式。***</span>
***Logger.h：***

```objective-c
#import <Foundation/Foundation.h>

@interface Logger : NSObject
- (void)log:(NSString *)message;
@end
```
***Logger.m：***
```objective-c
#import "Logger.h"

@implementation Logger
- (void)log:(NSString *)message {
    NSLog(@"%@", message);
}
@end
```
***UserService.h：***
```objective-c
#import <Foundation/Foundation.h>
#import "Logger.h"

@interface UserService : NSObject

@property(nonatomic, strong) Logger *logger;
- (instancetype)initWithLogger:(Logger *)logger;
- (void)doSomething;

@end
```
***UserService.m：***
```objective-c
#import "UserService.h"

@implementation UserService
- (instancetype)initWithLogger:(Logger *)logger {
    if (self = [super init]) {
        self.logger = logger;
    }return self;
}

- (void)doSomething {
    // 使用依赖注入的 Logger 对象记录日志
    [self.logger log:@"Something is done in UserService"];
}
@end
```
<span style="color:Blue; font-weight:bold;">***在这个示例中，`UserService` 类在构造函数中接受一个 `Logger` 对象作为参数，然后将其存储在实例变量中。这样，调用 `UserService` 的代码可以提供自己的 `Logger` 实例，从而实现了依赖注入。***</span>
## 函数（方法）签名
* 指函数的声明或定义，其中包含了***函数的名称***、***参数列表***和***返回类型***；
  * **函数名称：** 函数的标识符，用于唯一标识函数；
  * **参数列表：**包含函数接受的参数及其类型。参数列表可以为空，也可以包含一个或多个参数，每个参数包含参数名称和类型。在函数签名中，参数列表的顺序和参数类型是非常重要的，它们决定了函数调用时传递参数的方式；形参的顺序不会影响方法签名的确定。
  * **返回类型：** 指定函数执行完成后返回的值的类型。返回类型可以是任何数据类型，包括基本数据类型（例如整数、浮点数、布尔值等）以及复合数据类型（例如数组、结构体、对象等）；
* 它描述了函数的输入参数以及返回值的类型，用于**确定函数的类型和使用方式，用于唯一标识一个特定的函数或方法**；
## 方法的重载：<span style="color:red; font-weight:bold;">系统将会识别为2个不同的方法</span>

方法的重载（Overloading）是指在<span style="color:Blue; font-weight:bold;">***同一个类中***</span>定义<span style="color:Blue; font-weight:bold;">***多个同名但参数列表不同的方法***</span>
方法重载的关键是***方法的参数列表必须不同***。参数列表包括参数的类型、数量和顺序。
* Swift 支持方法的重载：***仅仅参数顺序不一致，Swift 不会将其视为方法重载***。因为 Swift 方法的标识符是由方法名和参数类型构成的，**参数顺序不会影响方法的标识符<span style="color:red; font-weight:bold;">（相对于Java语言，更加的严格）</span>
```swift
class MathFunctions {
    // 方法重载：参数为两个整数
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }

    // 方法重载：参数为三个整数
    func add(_ a: Int, _ b: Int, _ c: Int) -> Int {
        return a + b + c
    }

    // 方法重载：参数为两个浮点数
    func add(_ a: Double, _ b: Double) -> Double {
        return a + b
    }
}

let math = MathFunctions()

// 调用不同的重载方法
print("Sum of 2 and 3 is: \(math.add(2, 3))")
print("Sum of 2, 3 and 4 is: \(math.add(2, 3, 4))")
print("Sum of 2.5 and 3.5 is: \(math.add(2.5, 3.5))")
```
* OC 没有方法的重载
* Dart 没有方法的重载
* Java 支持方法的重载：***仅仅参数顺序不同，也会被视为重载的不同方法***
```java
public class OverloadExample {
    // 方法重载：参数为两个整数
    public int add(int a, int b) {
        return a + b;
    }

    // 方法重载：参数为三个整数
    public int add(int a, int b, int c) {
        return a + b + c;
    }

    // 方法重载：参数为两个浮点数
    public double add(double a, double b) {
        return a + b;
    }

    public static void main(String[] args) {
        OverloadExample example = new OverloadExample();

        // 调用不同的重载方法
        System.out.println("Sum of 2 and 3 is: " + example.add(2, 3));
        System.out.println("Sum of 2, 3 and 4 is: " + example.add(2, 3, 4));
        System.out.println("Sum of 2.5 and 3.5 is: " + example.add(2.5, 3.5));
    }
}
```
## <span style="color:red; font-weight:bold;">***OC.多线程***</span>
### pthread

* *pthread（**P**OSIX **Thread**s）*是一套<span style="color:red; font-weight:bold;">***C语言编写***</span>的**跨平台多线程API**，**使用难度大**，需要**手动管理线程生命周期**。（需要更加谨慎地处理线程的同步和互斥操作，以避免出现死锁、数据竞争等问题）
  * **线程创建和管理**： pthread 库允许程序员创建、销毁、等待和控制线程的执行。通过调用 pthread_create 函数，程序可以创建新的线程并指定线程执行的函数。程序还可以使用 pthread_join 函数等待线程的结束，并使用 pthread_exit 函数退出当前线程；
  * **线程同步**： pthread 提供了一系列的同步机制，如互斥锁（Mutex）、条件变量（Condition Variable）、信号量（Semaphore）等，可以用于多线程之间的同步和互斥操作。这些同步机制可以帮助程序员避免多个线程同时访问共享资源导致的竞态条件和数据不一致性问题；
  * **线程调度和优先级**： pthread 允许程序员设置线程的调度策略和优先级，以及控制线程的调度行为。程序员可以通过设置线程的属性来指定线程的调度策略和优先级，以及其他相关的属性；
  * **线程取消和退出**： pthread 允许程序员取消线程的执行，并在需要时优雅地退出线程。程序员可以使用 pthread_cancel 函数取消指定线程的执行，并使用 pthread_exit 函数主动退出当前线程；
  * **线程局部存储**： pthread 提供了线程局部存储（Thread-Specific Data，TSD）的机制，允许程序员为每个线程分配独立的存储空间。这些存储空间对于每个线程是私有的，可以用于存储线程特定的数据；
### NSThread

* Cocoa 框架中的一部分<span style="color:red; font-weight:bold;">***（较为底层）***</span>。面向对象操作线程，使用相对简单，需要手动管理线程生命周期；
  * **线程创建和管理**： 使用 `NSThread` 类，您可以创建新的线程，并通过调用 `start` 方法来启动线程的执行。您可以在创建线程时指定线程执行的方法，并传递参数给该方法。通过 `isExecuting` 和 `isFinished` 等属性，您可以查询线程的执行状态；
  * **线程调度和优先级**： `NSThread` 允许您设置线程的调度优先级，以及控制线程的调度行为。您可以使用 `threadPriority` 属性来设置线程的优先级，范围为 0.0 到 1.0，其中 1.0 表示最高优先级。您还可以使用 `sleepForTimeInterval:` 方法来让线程休眠一段时间；
  * **线程同步**： `NSThread` 并没有提供专门的同步机制，但您可以使用其他的同步机制，如互斥锁（`NSLock`）、条件变量（`NSCondition`）等，来确保多个线程之间的同步和互斥操作。您可以在不同的线程中使用这些同步机制来避免竞态条件和数据不一致性问题；
  * **线程退出**： `NSThread` 并没有提供退出线程的方法，但您可以通过让线程执行完其任务后自行退出来实现线程的结束。在线程的执行方法中，您可以使用 `exit` 方法或直接返回来退出线程；
  * **线程局部存储**： `NSThread` 并不直接支持线程局部存储的机制，但您可以使用线程的字典属性来实现类似的功能。每个 `NSThread` 对象都有一个 `threadDictionary` 属性，您可以使用这个属性来存储和访问线程特定的数据；
### GCD

* GCD（***G***rand ***C***entral ***D***ispatch）是苹果（Apple.Inc）多核编程解决方案（多线程处理技术），使用起来非常方便。需要自己实现如：限制并发数，任务间的依赖等功能。自动管理线程生命周期。
  * **队列（Dispatch Queues）**： GCD 使用队列来管理任务的执行。队列可以是串行队列（Serial Queue）或并发队列（Concurrent Queue）。串行队列中的任务按照 FIFO（先进先出）的顺序依次执行，而并发队列中的任务可以同时执行；
  * **任务（Blocks）**： 在 GCD 中，任务以块（Blocks）的形式表示。块是一段代码，可以在队列中异步或同步执行。您可以使用 GCD 提供的函数来创建并提交任务到队列中执行；
  * **同步和异步执行（Sync vs Async）**： 您可以使用同步（Sync）或异步（Async）的方式将任务提交到队列中执行。同步执行会阻塞当前线程，直到任务执行完毕；而异步执行会立即返回，任务在后台线程执行，不会阻塞当前线程；
  * **主队列和全局队列（Main and Global Queues）**： 主队列是一个串行队列，用于在应用程序的主线程上执行任务。全局队列是一个并发队列，由系统提供，可以用于执行后台任务。全局队列分为多个优先级，从高到低分别是高、默认、低和后台；
  * **信号量（Dispatch Semaphores）**： GCD 提供了***信号量机制***，可以控制并发任务的数量。通过信号量，您可以限制同时执行的任务数量，避免过多的并发导致资源竞争或性能问题；
  * **调度组（Dispatch Groups）**： 调度组是一种用于管理多个任务的机制，它可以让您监视一组任务的完成状态。您可以使用调度组来等待一组任务全部完成后再执行其他操作，或者在一组任务完成时执行特定的处理；
* 线程组：`dispatch_group_t`
  * 允许等待一组任务完成后再执行其他操作；
  * 可以向线程组添加任务，并使用`dispatch_group_notify`方法来设置一个回调，该回调将在所有任务完成后被调用；

```objective-c
// 导入必要的头文件
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建一个串行队列
        dispatch_queue_t queue = dispatch_queue_create("com.example.queue", DISPATCH_QUEUE_SERIAL);
        // 创建一个线程组
        dispatch_group_t group = dispatch_group_create();
        // 向线程组中添加任务
        dispatch_group_async(group, queue, ^{
            // 第一个异步任务
            NSLog(@"Task 1 started");
            sleep(2); // 模拟耗时操作
            NSLog(@"Task 1 completed");
        });
        dispatch_group_async(group, queue, ^{
            // 第二个异步任务
            NSLog(@"Task 2 started");
            sleep(3); // 模拟耗时操作
            NSLog(@"Task 2 completed");
        });
        // 设置一个回调，在所有任务完成后执行
        dispatch_group_notify(group, queue, ^{
            NSLog(@"All tasks completed");
        });
        // 等待线程组中的任务完成
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"Main thread continues after all tasks completed");
    }return 0;
}
/**
创建了一个串行队列和一个线程组。
然后，向线程组中添加了两个异步任务，并设置了一个回调，以便在所有任务完成后执行。
最后，调用了dispatch_group_wait函数，使当前线程等待线程组中的任务完成。
*/
```

* GCD的定时器

*创建了一个定时器，每隔1秒执行一次任务。定时器在10秒后被取消，然后程序退出。可以根据需要调整定时器的间隔时间。*

***OC.GCD.Timer***

```objective-c
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建DispatchSourceTimer对象
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 
                                                         0, 
                                                         0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        // 设置定时器的初始时间、间隔时间和精度
        dispatch_source_set_timer(timer,
                                  dispatch_time(DISPATCH_TIME_NOW, 0), 
                                  1ull * NSEC_PER_SEC, 
                                  100ull * NSEC_PER_MSEC);
        // 设定定时器的执行任务
        dispatch_source_set_event_handler(timer, ^{
            // 这里是定时器触发时执行的任务
            NSLog(@"Timer fired!");
        });
        // 启动定时器
        dispatch_resume(timer);
        // 为了让程序不立即结束，可以让主线程等待一段时间
        // 这里只是为了演示目的，实际中你可能会有其他的需要
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 
                                     (int64_t)(10.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            // 取消定时器
            dispatch_source_cancel(timer);
            NSLog(@"Timer canceled!");
            // 退出程序
            exit(EXIT_SUCCESS);
        });
        // 让主线程开始运行RunLoop，以便定时器能够工作
        NSRunLoop.mainRunLoop.run;
    }return 0;
}
```

***Swift.GCD.Timer***

```swift
import Foundation

// 创建一个DispatchSourceTimer对象
let timer = DispatchSource.makeTimerSource()
// 设置定时器的初始时间、间隔时间和队列
timer.schedule(deadline: .now(),
               repeating: .seconds(1), 
               leeway: .milliseconds(100))
// 设定定时器的执行任务
timer.setEventHandler {
    // 这里是定时器触发时执行的任务
    print("Timer fired!")
}
// 获取一个全局队列并将定时器事件处理程序调度到该队列上
let queue = DispatchQueue.global()
timer.setEventHandler(handler: {
    queue.async {
        print("Timer fired!")
    }
})
// 启动定时器
timer.activate()
// 为了让程序不立即结束，可以让主线程等待一段时间
// 这里只是为了演示目的，实际中你可能会有其他的需要
let mainQueue = DispatchQueue.main
mainQueue.asyncAfter(deadline: .now() + .seconds(10)) {
    // 取消定时器
    timer.cancel()
    print("Timer canceled!")
    // 退出程序
    exit(EXIT_SUCCESS)
}
// 让主线程开始运行RunLoop，以便定时器能够工作
RunLoop.main.run()
/**
  这段代码创建了一个定时器，每隔1秒执行一次任务。
  你可以根据需要调整定时器的间隔时间。
  在这个例子中，定时器在10秒后被取消，然后程序退出。
*/
```

### NSOperation

* <span style="color:red; font-weight:bold;">***基于GCD***</span>的封装，面向对象操作线程，提供了比[***GCD***](# GCD)更丰富的API：限制最大并发数，设置任务依赖关系；
* 但是它<span style="color:red; font-weight:bold;">***它不能直接使用***</span>，因为它是一个抽象类，可以继承它或者使用系统定义*NSInvocationOperation*或*NSBlockOperation*。自动管理线程生命周期；
  * **任务管理**： *NSOperation* 封装了一个执行任务的对象，可以用于执行各种类型的任务。您可以通过子类化 *NSOperation* 类，实现自定义的任务逻辑，并在其中执行所需的操作。
  * **任务依赖**： *NSOperation* 提供了任务依赖的机制，允许您指定任务之间的依赖关系。这样，您可以确保某个任务在其依赖的所有任务完成后才开始执行。通过 `addDependency:` 方法，您可以为一个操作添加一个或多个依赖。
  * **任务队列**： *NSOperationQueue* 是用于管理 *NSOperation* 对象的队列，它负责调度和执行队列中的操作。您可以将操作添加到队列中，并指定执行顺序、并发性等属性。队列可以是串行队列或并发队列，分别用于按顺序执行任务或并行执行任务。
  * **线程管理**： *NSOperation* 可以自动管理线程，无需手动创建线程。*NSOperationQueue* 内部会自动创建并管理线程池，根据需要创建和回收线程，以确保任务的高效执行。
  * **取消和暂停**： *NSOperation* 提供了取消和暂停任务的机制。您可以调用 `cancel` 方法取消任务的执行，或者调用 `setSuspended:` 方法暂停队列的执行。取消任务不会立即终止任务的执行，但会在任务执行下一个检查点时提前结束任务。
  * **KVO 监听**： *NSOperation* 支持 [***KVO（Key-Value Observing）***](# KVO（<span style="color:red; font-weight:bold;">***K***</span>ey-<span style="color:red; font-weight:bold;">***V***</span>alue <span style="color:red; font-weight:bold;">***O***</span>bserving）：**属性观察)，允许您监视操作的执行状态和属性的变化。通过观察操作的 `isExecuting`、`isFinished` 和 `isCancelled` 等属性，您可以了解操作的执行情况。
## ***OC.Runtime.消息转发机制***

Objective-C 中的消息转发机制是一种在***运行时动态处理未知消息***的机制：<span style="color:red; font-weight:bold;">***当一个对象接收到一个它无法识别的消息时，Objective-C 运行时系统会通过一系列的步骤来处理这个未知消息，并尝试找到合适的接收者来处理该消息***</span>。
消息转发机制一般分为三个阶段：

1. **动态方法解析（Dynamic Method Resolution）**：
   在这个阶段，Objective-C 运行时会调用类方法 `+resolveInstanceMethod:` 或 `+resolveClassMethod:`。通过这些方法，类有机会动态添加方法实现，从而使得接收到的消息可以被处理。如果方法解析成功，消息将被重发，重新执行；
2. **备用接收者（Fallback Recipients）**：
   如果动态方法解析失败，Objective-C 运行时会调用 `-forwardingTargetForSelector:` 方法，以寻找备用接收者来处理消息。在这个方法中，对象有机会返回另一个对象来处理该消息。如果返回了一个非空的对象，则消息将被转发到这个对象，而不再继续后续的步骤；
3. **完整消息转发（Complete Message Forwarding）**：
   如果备用接收者也无法处理消息，最后的选择是使用完整的消息转发机制。Objective-C 运行时会调用 `-forwardInvocation:` 方法，并将消息包装成一个 *NSInvocation* 对象传递给该方法。在 `-forwardInvocation:` 方法中，对象可以选择将消息发送给其他对象，或者抛出异常，或者其他自定义处理。如果 `-forwardInvocation:` 方法没有被实现，或者在其中没有将消息发送给其他对象，那么将会抛出一个 *NSInvalidArgumentException* 异常。
   通过这三个阶段，Objective-C 运行时可以实现动态消息处理的能力，使得对象能够在运行时动态地处理未知消息，从而增强了语言的灵活性和动态性；
## ***OC.database***
### ***OC.SQLite***

* 零配置：可在无需配置的情况下使用的简单的数据库引擎
* C库：跨平台
* 适用于嵌入式系统、移动应用和小型项目

***需要在Xcode项目中添加`libsqlite3.tbd`库***

```objective-c
#import <sqlite3.h>
// 打开数据库连接
sqlite3 *database;
NSString *databasePath;

NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0];
databasePath = [documentsDirectory stringByAppendingPathComponent:@"test.db"];

if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
    NSLog(@"数据库打开成功！");
    // 创建表格
    const char *sqlStatement = "CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)";
    char *errorMessage;
    if (sqlite3_exec(database, sqlStatement, NULL, NULL, &errorMessage) != SQLITE_OK) {
        NSLog(@"创建表格失败: %s", errorMessage);
    }
    // 插入数据
    const char *insertStatement = "INSERT INTO contacts (name, age) VALUES (?, ?)";
    sqlite3_stmt *compiledStatement;
    if (sqlite3_prepare_v2(database, insertStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        sqlite3_bind_text(compiledStatement, 1, [@"John Doe" UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(compiledStatement, 2, 30);

        if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
            NSLog(@"插入数据失败！");
        }
    }
    sqlite3_finalize(compiledStatement);
    // 查询数据
    const char *selectStatement = "SELECT * FROM contacts";
    if (sqlite3_prepare_v2(database, selectStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
            int contactID = sqlite3_column_int(compiledStatement, 0);
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            int age = sqlite3_column_int(compiledStatement, 2);
            NSLog(@"ID: %d, Name: %@, Age: %d", contactID, name, age);
        }
    }
    sqlite3_finalize(compiledStatement);
    // 关闭数据库连接
    sqlite3_close(database);
} else {
    NSLog(@"数据库打开失败！");
}
```
### ***OC.FMDB***
* **需要使用SQL语言**
* 对***[SQLite](# OC.SQLite)进行封装***的库（纯OC库，跨平台性不佳），***[SQLite](# OC.SQLite)***本身是一个轻量级的数据库引擎，在处理小型数据集时性能良好。但是在<span style="color:red; font-weight:bold;">***处理大型数据集时可能会出现性能瓶颈***</span>
* 本身不提供实时数据同步功能，如果需要实现实时数据同步，你需要自己编写代码来实现
```objective-c
// ViewController.m
#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()
@property (nonatomic, strong) FMDatabase *database;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取沙盒中数据库文件路径
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databasePath = [docsDir stringByAppendingPathComponent:@"test.db"];
    // 初始化数据库
    self.database = [FMDatabase databaseWithPath:databasePath];
    if (!self.database.open) {
        NSLog(@"Could not open database.");
        return;
    }
    // 创建表格
    BOOL success = [self.database executeUpdate:@"CREATE TABLE IF NOT EXISTS contacts (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)"];
    if (!success) {
        NSLog(@"Error creating table: %@", self.database.lastErrorMessage);
    }
    // 插入数据
    success = [self.database executeUpdate:@"INSERT INTO contacts (name, age) VALUES (?, ?)", @"John Doe", @(30)];
    if (!success) {
        NSLog(@"Error inserting data: %@", self.database.lastErrorMessage);
    }
    // 查询数据
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT * FROM contacts"];
    while (resultSet.next) {
        NSString *name = [resultSet stringForColumn:@"name"];
        NSInteger age = [resultSet intForColumn:@"age"];
        NSLog(@"Name: %@, Age: %ld", name, (long)age);
    }
    // 更新数据
    success = [self.database executeUpdate:@"UPDATE contacts SET age = ? WHERE name = ?", @(35), @"John Doe"];
    if (!success) {
        NSLog(@"Error updating data: %@", self.database.lastErrorMessage);
    }
    // 删除数据
    success = [self.database executeUpdate:@"DELETE FROM contacts WHERE name = ?", @"John Doe"];
    if (!success) {
        NSLog(@"Error deleting data: %@", self.database.lastErrorMessage);
    }
    
    [self.database close];
}

@end
```
### ***OC.Realm（强烈推荐）***
* <span style="color:red; font-weight:bold;">***不需要会SQL语言***</span>
* 跨平台
* 实时数据同步

```objective-c
#import <Realm/Realm.h>

// 定义数据模型
@interface Person : RLMObject
@property NSString *name;
@property NSInteger age;
@end

@implementation Person
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建 Realm 数据库实例
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        // 执行数据库操作
        [realm transactionWithBlock:^{
            // 增加数据
            Person *person = Person.new;
            person.name = @"John";
            person.age = 30;
            [realm addObject:person];
            // 查询数据
            RLMResults<Person *> *persons = Person.allObjects;
            NSLog(@"Number of persons: %lu", (unsigned long)persons.count);
            for (Person *person in persons) {
                NSLog(@"Name: %@, Age: %ld", person.name, (long)person.age);
            }
            // 修改数据
            Person *firstPerson = persons.firstObject;
            if (firstPerson) {
                firstPerson.age = 31;
            }
            // 删除数据
            [realm deleteObject:firstPerson];
        }];
    }return 0;
}
```
## 在OC里面NSString用`copy`修饰 还是`Strong`修饰？

在Objective-C中，对于*NSString*这样的不可变对象，通常建议使用 `copy` 修饰符而不是 `strong`。

* 这是因为*NSString*是不可变的，一旦创建就不会被修改；

* 使用 `copy` 修饰符可以确保在设置新值时创建一个新的副本，而不是简单地增加引用计数；

当使用 `strong` 修饰符时，如果将一个*NSMutableString*赋值给一个*NSString*类型的属性，那么它***实际上仍然可以被修改***，这可能会导致意外的行为。因此，为了确保不可变性，通常建议使用 `copy` 修饰符来保护*NSString*对象。

## 其他

* <span style="color:purple; font-weight:bold;">**打开了VPN，使用Charles抓包工具会失灵**</span>

* <span style="color:purple; font-weight:bold;">**Git 不允许在一个仓库中嵌套另一个Git仓库**。</span>这是因为每个Git仓库都需要有一个独特的`.git`目录来存储版本控制相关的信息，而如果嵌套使用，就会导致冲突和混淆。
  在你的情况下，有几个备选的解决方案：
  
  * **子模块（Submodule）：**
  使用 Git 的子模块是一个常见的方法，可以将一个仓库嵌套到另一个仓库中。你可以将每个子文件夹作为一个独立的子模块。子模块允许你将其他Git仓库嵌套到你的项目中，每个子模块有自己的`.git`目录。
  在你的主项目目录中运行：
  ```bash
  git submodule add <repository-url> <path-to-submodule>
  ```
  其中，`<repository-url>` 是子模块的Git仓库地址，`<path-to-submodule>` 是子模块存储的目录路径。
  * **单一仓库：**
  如果你希望这三个子文件夹共享同一个Git仓库，而不是各自有独立的仓库，那么可以将它们合并为一个单一的Git仓库。将这三个子文件夹的内容复制到主项目目录下，然后使用一次性的 `git init` 进行初始化。
  ```bash
  cd /path/to/main/project
  git init
  git add .
  git commit -m "Initial commit"
  ```
  这样，你的整个项目都在同一个仓库中了。
  * **多个独立仓库：**
  如果你希望保持这三个子文件夹的独立性，而且不希望使用子模块，你可以维护这四个仓库（主项目和三个子项目）作为独立的Git仓库。这样，你需要在每个子文件夹中独立进行版本控制。
  选择哪种方法取决于你的具体需求，每个方法都有其优劣之处。子模块通常用于处理外部依赖，而将所有内容放在一个仓库中可能更容易管理，但这也取决于你的项目结构和开发流程。
  
* <span style="color:purple; font-weight:bold;">**`ping`命令不应该包含协议（如HTTP）或端口号**。</span>因为它是一个基于网络层的命令，主要用于测试主机之间的连接。正确的`ping`命令格式是：
  ```bash
  ping 10.242.91.199
  ```
  如果你想测试特定端口的连接，可以使用其他工具，例如`telnet`。例如，要测试特定端口8070的连接，可以使用以下命令：
  ```bash
  telnet 10.242.91.199 8070
  ```
  请注意，`telnet`命令可能需要安装，具体取决于你的操作系统。
  
* <span style="color:purple; font-weight:bold;">**在浏览器中使用IP地址访问网站时，通常可以省略"HTTP://"。**</span>**浏览器会默认使用HTTP协议**，除非指定了其他协议（例如https）。因此，你可以直接在浏览器地址栏中输入IP地址，如下所示：
  ```
  http://123.456.789.123
  ```
  如果网站启用了https，并且你想要通过安全的HTTPS连接进行访问，可以在IP地址前加上`https://`，如下所示：
  ```
  https://123.456.789.123
  ```
  总之，大多数情况下，你可以省略`http://`，但如果需要访问https站点，就需要在IP地址前加上`https://`
  
* <span style="color:purple; font-weight:bold;">**配置GitHub的SSH（Secure Shell）可以帮助您更安全地与GitHub仓库进行通信。**</span>以下是配置GitHub SSH的步骤：
  * **生成SSH密钥：**
    打开终端（在Linux或macOS上）或Git Bash（在Windows上），然后运行以下命令生成SSH密钥：
  ```bash
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
  ```
    替换`your_email@example.com`为您在GitHub上注册的电子邮件地址。
  
    按照提示，您可以选择性地输入文件名和密码。
  
    如果您不输入文件名，将使用默认的`id_rsa`和`id_rsa.pub`文件。
  * **将SSH密钥添加到ssh-agent（仅适用于Linux和macOS）：**如果您使用Linux或macOS，可以通过以下命令将SSH密钥添加到ssh-agent：
  ```bash
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa
  ```
    请注意，`~/.ssh/id_rsa`是您生成的SSH密钥的路径，如果您选择了不同的文件名，则相应地更改。
  * **将SSH密钥添加到GitHub帐户：**复制SSH密钥的内容：
  ```bash
  cat ~/.ssh/id_rsa.pub
  ```
    然后，将输出的公钥复制到GitHub上。
    登录GitHub，转到`Settings` > `SSH and GPG keys` > `New SSH key`，将公钥粘贴到"Key"字段中，并为密钥命名。
  * **测试SSH连接:**运行以下命令测试SSH连接：
  ```bash
  ssh -T git@github.com
  ```
  如果一切设置正确，您将看到一条欢迎消息，并确认连接成功；
  这样，您就成功配置了GitHub的SSH，可以通过SSH安全地与GitHub仓库通信，**而无需每次都输入用户名和密码**；
  请记住，安全性是关键，因此请**妥善保存私钥**，并避免在不受信任的地方使用私钥。
  
* <span style="color:purple; font-weight:bold;">**文件数据则可以通过 `multipart/form-data` 格式进行编码，并作为消息体的一部分发送到服务器（用POST）**</span>

* <span style="color:purple; font-weight:bold;">***iOS*推送通知：**</span>**向用户设备发送消息的机制，允许开发者在用户设备上显示提醒、声音和标志等通知**
  * **推送通知类型**：
    - **本地通知**：***由应用程序本身发出，无需连接到远程服务器***。本地通知可以在特定时间触发或在用户进入或退出特定地理位置时触发；

    ```objective-c
    #import "ViewController.h"
    #import <UserNotifications/UserNotifications.h>
    
    @implementation ViewController
    
    - (void)viewDidLoad {
        [super viewDidLoad];
    }
    /**
    	用户点击按钮时，将触发一个本地通知。
    	本地通知的标题和正文内容已经设置，并且在 5 秒后触发。
    	当用户收到通知时，设备将会播放默认提示音
    */
    - (IBAction)scheduleLocalNotification:(UIButton *)sender {
        UNMutableNotificationContent *content = UNMutableNotificationContent.new;
        content.title = @"本地通知标题";
        content.body = @"这是一个本地通知示例";
        content.sound = UNNotificationSound.defaultSound;
        // 触发时间为 5 秒后
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        // 创建通知请求
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"localNotification" 
                                                                              content:content
                                                                              trigger:trigger];
        // 将通知请求添加到用户通知中心
        [UNUserNotificationCenter.currentNotificationCenter addNotificationRequest:request 
                                                             withCompletionHandler:^(NSError * _Nullable error) {
    				if (error) {
                NSLog(@"添加本地通知请求出错：%@", error.localizedDescription);
            } else {
                NSLog(@"本地通知请求已添加成功");
            }
        }];
    }
    
    @end
    ```
    ```swift
    import UIKit
    import UserNotifications
    
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // 请求通知权限
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted {
                    print("用户已授权通知权限")
                } else {
                    print("用户未授权通知权限")
                }
            }
            // 注册远程通知
            application.registerForRemoteNotifications()
            // 设置 UNUserNotificationCenterDelegate
            UNUserNotificationCenter.current().delegate = self
            return true
        }
        // 处理远程通知注册成功
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            print("远程通知注册成功，设备令牌：\(deviceToken)")
            // 将设备令牌发送给后端服务器
        }
        // 处理远程通知注册失败
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("远程通知注册失败：\(error.localizedDescription)")
        }
        // 接收远程通知
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            print("接收到远程通知：\(notification.request.content.userInfo)")
            // 在此处理接收到的通知
            // 播放提示音
            completionHandler([.alert, .sound])
        }
        // iOS 10 及以上版本的接收远程通知的方法
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("接收到远程通知响应：\(response.notification.request.content.userInfo)")
            // 在此处理接收到的通知响应
            completionHandler()
        }
    }
    ```
    
    *在`Info.plist`文件中添加**请求通知权限的配置**代码*
    
    ```xml
    <key>NSUserNotificationAlertStyle</key>
    <string>alert</string>
    <key>UIUserInterfaceStyle</key>
    <string>Light</string>
    ```
    *在 **AppDelegate.m***中的`didFinishLaunchingWithOptions`方法内，添加如下代码：*
    ```objective-c
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"用户已授权通知权限");
        } else {
            NSLog(@"用户未授权通知权限");
        }
    }];
    ```
    - **远程通知**：***由远程服务器发出，通过苹果的 APNs 服务将通知发送到用户设备上***。远程通知允许开发者在应用程序不在前台时向用户发送消息；
  * **APNs 服务:** ***A***pple ***P***ush ***N***otification ***s***ervice
    
    - 开发者需要在*[苹果开发者中心](https://developer.apple.com/cn/)*注册应用程序的 ***bundle identifier***，并获取一个 ***APNs 证书***来与 APNs 服务器通信；
    - 通过 APNs 服务，开发者可以向用户设备发送远程通知，并指定通知的内容、声音、标志等参数；
    ```json
    {
      "aps": {
          "alert": {
              "title": "远程通知标题",
              "body": "这是一个远程通知示例"
          },
          "badge": 1,// 应用程序图标上要显示的徽章数量
          "sound": "default",// 系统缺省值声音
              // 或者
          "sound": "custom_sound.mp3"// 自定义的声音文件（包括文件名和文件扩展名）。如果通知负载中没有指定声音，系统将使用默认的提示音
      }
    }
    ```
  * **推送通知的实现**：
    - 在应用程序中配置推送通知的权限，并请求用户允许发送通知；
    - 使用 Apple 提供的 ***UNUserNotificationCenter*** API 来请求用户的推送通知权限，并处理用户对通知的响应；
    - 配置应用程序的通知设置，包括通知内容、声音、标志等；
    - 在应用程序的远程服务器端生成和发送推送通知。服务器端通常使用推送通知服务商提供的 API 来与 APNs 服务器通信，如 ***F***irebase ***C***loud ***M***essaging（FCM）、***OneSignal*** 等；
    - 接收到推送通知后，应用程序可以在前台或后台执行一些自定义逻辑，如更新界面、处理数据等；
  ```objective-c
  #import "AppDelegate.h"
  #import <UserNotifications/UserNotifications.h>
  
  @interface AppDelegate () <UNUserNotificationCenterDelegate>
  
  @end
  
  @implementation AppDelegate
  
  - (BOOL)application:(UIApplication *)application 
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      // 请求通知权限
      [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) 
       completionHandler:^(BOOL granted, NSError * _Nullable error) {
          if (granted) {
              NSLog(@"用户已授权通知权限");
          } else {
              NSLog(@"用户未授权通知权限");
          }
      }];
      // 注册远程通知
      [UIApplication.sharedApplication registerForRemoteNotifications];
      // 设置 UNUserNotificationCenterDelegate
      UNUserNotificationCenter.currentNotificationCenter.delegate = self;
      return YES;
  }
  // 处理远程通知注册成功
  - (void)application:(UIApplication *)application
  didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
      NSLog(@"远程通知注册成功，设备令牌：%@", deviceToken);
      // 将设备令牌发送给后端服务器
  }
  // 处理远程通知注册失败
  - (void)application:(UIApplication *)application
  didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
      NSLog(@"远程通知注册失败：%@", error.localizedDescription);
  }
  // 接收远程通知
  - (void)application:(UIApplication *)application
  didReceiveRemoteNotification:(NSDictionary *)userInfo
  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
      NSLog(@"接收到远程通知：%@", userInfo);
      // 在此处理接收到的通知
      completionHandler(UIBackgroundFetchResultNewData);
  }
  // iOS 10 及以上版本的接收远程通知的方法
  - (void)userNotificationCenter:(UNUserNotificationCenter *)center 
  didReceiveNotificationResponse:(UNNotificationResponse *)response
  withCompletionHandler:(void (^)(void))completionHandler {
      NSLog(@"接收到远程通知响应：%@", response.notification.request.content.userInfo);
      // 在此处理接收到的通知响应
      completionHandler();
  }
  
  @end
  ```
  * **推送通知的处理**：
    - 当用户收到推送通知时，通知会显示在设备的通知中心，并发出声音和/或振动。用户可以点击通知来打开应用程序或执行其他操作；
    - 应用程序可以在接收到推送通知时执行自定义操作，如展示特定界面、更新数据等；
  * **注意事项**：
    - 推送通知的发送需要注意用户隐私和数据保护法规，确保用户的个人数据不被滥用；
    - 在发送推送通知时，需要考虑用户体验，避免发送过多或无关紧要的通知，以免打扰用户；
