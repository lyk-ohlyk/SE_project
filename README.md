## 这是高级软件工程第13组的大作业
项目部署地址：https://moyuu.herokuapp.com

#### 组员为：
田秋凝，github:  
徐可馨，github: [cordaX](https://github.com/cordaX)  
门琳琳，github: [Alin3217](https://github.com/Alin3217)  
刘炎堃，github: [lyk-ohlyk](https://github.com/lyk-ohlyk)  
刘鹏坤，github: [liupengkun](https://github.com/liupengkun)  

## 关于该文档
This document was ...

## 目录

* [项目介绍](#1-%E9%A1%B9%E7%9B%AE%E4%BB%8B%E7%BB%8D)  
  * [项目的意义](#%E9%A1%B9%E7%9B%AE%E7%9A%84%E6%84%8F%E4%B9%89)  
  * [项目的目标](%E9%A1%B9%E7%9B%AE%E7%9A%84%E7%9B%AE%E6%A0%87)  
* [项目的技术和实施方案](#2-%E9%A1%B9%E7%9B%AE%E7%9A%84%E6%8A%80%E6%9C%AF%E5%92%8C%E5%AE%9E%E6%96%BD%E6%96%B9%E6%A1%88)  
  * [技术](#%E6%8A%80%E6%9C%AF)  
    * [版本控制工具](#%E7%89%88%E6%9C%AC%E6%8E%A7%E5%88%B6%E5%B7%A5%E5%85%B7)  
    * [协作开发工具](#%E5%8D%8F%E4%BD%9C%E5%BC%80%E5%8F%91%E5%B7%A5%E5%85%B7)  
    * [数据库](#%E6%95%B0%E6%8D%AE%E5%BA%93)  
  * [实施的方案](#%E5%AE%9E%E6%96%BD%E7%9A%84%E6%96%B9%E6%A1%88)  
    * [应用框架](#%E5%BA%94%E7%94%A8%E6%A1%86%E6%9E%B6)  
    * [运行环境](#%E8%BF%90%E8%A1%8C%E7%8E%AF%E5%A2%83)  
* [项目具体设计](#3-%E9%A1%B9%E7%9B%AE%E5%85%B7%E4%BD%93%E8%AE%BE%E8%AE%A1)  
* [User stories](#user-stories)  
  * [TDD test cases](#tdd-test-cases)  
  * [bala](#balabala)  


## 1. 项目介绍
### 项目的意义
国科大的课程网站里面有非常丰富的内容，但在使用中常常有所不便——如作业发布没有提醒，日程表显示杂乱等等。总的来说，课程网站里面的内容几乎什么都有，同时也都不怎么好用。  
这个项目的初衷，就是能利用课程网站的信息去给用户提供更好的服务，如作业发布后邮件提醒、为用户提供以课程为基础的日程表等等，为同学的生活、学习提供方便。  
所以，这个项目的目的是整合课程（和讲座等）信息，并帮助同学进行时间管理（日程表、邮件通知等）。

### 项目的目标
实现对课程网站的信息的整合，为网站的每个用户提供信息和日程管理服务。

## 2. 项目的技术和实施方案
### 技术
系统应用架构如下图所示：
![Markdown](http://i4.bvimg.com/630972/4fb6ab85e04820fd.png)
信息门户层：该层位于系统的顶层，面向网站的所有用户提供业务处理功能，
根据需求分析，用户可以划分为网站管理员、学生、教师等。用
户进行业务处理主要通过界面友好的功能界面实现。
 
业务应用层：该层是系统的核心层，通过操作界面向用户提供各类业务处理，
根据需求分析，可以将系统的应用划分为课程管理，讲座管理和日程管理等。
 
基础组件层：该层主要面向业务应用提供支撑，是业务处理所依赖的重要接
口和方法，如爬虫组件，推荐系统和日志组件等。
 
硬件设备层：该层位于系统架构的底层，面向其它层提供运行支撑，如服务器系统、备份系统、存储系统等。
#### 版本控制工具
项目采用git版本控制，采用github托管平台，[github项目地址](https://github.com/lyk-ohlyk/SE_project)。
#### 协作开发工具
小组采用rubymine这款强大的IDE，大大提高了开发效率，[rubymine官网下载地址](http://www.jetbrains.com/ruby/)。
#### 数据库
项目针对数据量小、结构简单的特点，采用了适合项目的sqlite3数据库。数据库结构模型如下。![Markdown](http://i2.bvimg.com/630972/0c797677ce5365d6.png)

### 实施的方案
#### 应用框架
项目主要基于rails框架进行web开发，利用了rails的多种开源模块，极大加快了开发进度。
#### 运行环境
项目部署在heroku平台，在主流浏览器中均可正常运行，详见[运行地址](https://moyuu.herokuapp.com/)。
## 3. 项目具体设计
为了能更好地运用rails，我们选择以Micheal Hartl的Ruby on Rails 4 Tutorial为参考，以MVC架构来组织软件。
### Model(模型)列表
User： 用户，记录了用户信息、用户之间的关系和用户与课程之间关系等。  
Micropost： 微博，是Ruby on Rails 4 Tutorial中实现的一个模型，可以发布、更新。  
Relationship： 记录用户关联关系的模型。  
Course： 课程模型，用于表示国科大的各个课程。  
Relatecourse： 记录用户和课程之间的关联关系的模型。  
Assignment： 课程作业。  
Comment（未完成)： 课程评论。
![Markdown](https://raw.githubusercontent.com/lyk-ohlyk/SE_project/master/Doc/Model.png)

#### User Stories
由于用户和微博模型相关的测试已经在Tutorial中写了大部分，项目的开发过程中只写了与Course的User stories。  
0. As a user, I want to see all the courses of USTC in courses page, so that I can be able to see their infomations.  
1. As a user, I want to see the courses I learned in my profile page.  
2. As a user, I want to see the courses a user learned in his profile page.  
3. As a user, I want to be able to unlearn some courses I don't like, they should not be shown in my profile page.  
4. As a learner, I want to know the recent homework assignments of my courses in my home page, so that I can be able to finish it on time.  
5. As a new student in USTC, I want to see others opinions of courses in course page, so that I can get advice of choosing which course to learn.  (实现中)
6. As a learner, I want to be emailed when a new assignment is published. (以下均未实现)
7. As a punctual one, I want to list the courses on a calendar, so that I can be able to make a good plan.  
8. As a punctual one, I want to be able to add/delete my event on the calendar.  
9. As a punctual one, I want to classify different events on the calendar in different colors.  
10. ...
#### TDD test cases
在编写程序过程中，大部分遵守了TDD的思路：Red - Green - Refactor
所有的[spec文件](https://github.com/lyk-ohlyk/SE_project/tree/master/spec)都是TDD test cases.
下面是一个testcase的例子。


#### balabala


