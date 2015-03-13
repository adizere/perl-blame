# Introduction #

The UML diagram containing the classes and the relashionships between them can be found in /trunk/docs/ in .png format.

![http://perl-blame.googlecode.com/svn/trunk/docs/perl-blame(Apollo)-UML.png](http://perl-blame.googlecode.com/svn/trunk/docs/perl-blame(Apollo)-UML.png)

# Distribution Namespaces #

  * **Apollo**
Top level namespace: designates the project name. All the classes  hierarchy is contained inside this namespace.

  * **Apollo::Logger**
The classes needed in order to properly distribute the logging facility across multiple objects reside here.

  * **Apollo::Logger::Delegates**
In here the logging functionalities are kept, inside classes which designate the logging destination (ex: stdout, stderr, etc..), i.e. delegates used by the Logger class to direct the messages (or entries) to.

Some delegates need more that to only "direct a message", for example the Db delegates needs proper tables to be initialized, moreover, different DB systems declare their tables in different manners.

  * **Apollo::Logger::Delegates::Db**
The Db delegate holds in this namespace 2 essential objects, each of them being particular to the DB system used:
  1. a database handle;
  1. an SQL statements container (used for holding SQL statements that differ from system to system);

  * **Apollo::Logger::Delegates::Db::SqlContainer**
As was just mentioned above, this namespace has the role of keeping particular SQL statements inside their container.