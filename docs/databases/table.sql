-- -------------------------------- mm_wiki
-- mm-wiki 表结构
-- author: phachon
-- --------------------------------

-- 手动安装时首先需要创建数据库
-- create database if not exists mm_wiki default charset utf8;

-- --------------------------------
-- 用户表
-- --------------------------------
drop table if exists mm_wiki.mw_user purge;
create table mm_wiki."mw_user" (
  "user_id" int not null primary key identity(1,1) , --comment '用户 id',
  "username" varchar(100) not null default '', --comment '用户名',
  "password" varchar(32) not null default '', --comment '密码',
  "given_name" varchar(50) not null default '', --comment '姓名',
  "mobile" varchar(13) not null default '', --comment '手机号',
  "phone" varchar(13) not null default '', --comment '电话',
  "email" varchar(50) not null default '', --comment '邮箱',
  "department" varchar(50) not null default '', --comment '部门',
  "position" varchar(50) not null default '', --comment '职位',
  "location" varchar(50) not null default '', --comment '位置',
  "im" varchar(50) not null default '', --comment '即时聊天工具',
  "last_ip" varchar(15) not null default '', --comment '最后登录ip',
  "last_time" bigint not null default 0, --comment '最后登录时间',
  "role_id" tinyint not null default 0, --comment '角色 id',
  "is_forbidden" tinyint not null default 0, --comment '是否屏蔽，0 否 1 是',
  "is_delete" tinyint not null default 0, --comment '是否删除，0 否 1 是',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='用户表';

-- ---------------------------------------------------------------
-- 系统角色表
-- ---------------------------------------------------------------
drop table if exists mm_wiki.mw_role purge;
create table mm_wiki."mw_role" (
  "role_id" int not null primary key identity(1,1) , --comment '角色 id',
  "name" varchar(10) not null default '', --comment '角色名称',
  "type" tinyint not null default 0, --comment '角色类型 0 自定义角色，1 系统角色',
  "is_delete" tinyint not null default 0, --comment '是否删除，0 否 1 是',
  "create_time" int  not null default 0, --comment '创建时间',
  "update_time" int  not null default 0 --comment '更新时间',
) ;--, --comment='系统角色表';

-- -------------------------------------------------------
-- 系统权限表
-- -------------------------------------------------------
drop table if exists mm_wiki.mw_privilege purge;
create table mm_wiki."mw_privilege" (
  "privilege_id" int not null primary key identity(1,1)  , --comment '权限id',
  "name" varchar(30) not null default '', --comment '权限名',
  "parent_id" int  not null default 0, --comment '上级',
  "type" varchar(100) not null default 'controller', --comment '权限类型：控制器、菜单',
  "controller" varchar(100) not null default '', --comment '控制器',
  "action" varchar(100) not null default '', --comment '动作',
  "icon" varchar(100) not null default '', --comment '图标（用于展示)',
  "target" varchar(200) not null default '', --comment '目标地址',
  "is_display" tinyint not null default 0, --comment '是否显示：0不显示 1显示',
  "sequence" int not null default 0, --comment '排序(越小越靠前)',
  "create_time" int  not null default 0, --comment '创建时间',
  "update_time" int  not null default 0 --comment '更新时间',
) ;--, --comment='系统权限表';

-- ------------------------------------------------------------------
-- 系统角色权限对应关系表
-- ------------------------------------------------------------------
drop table if exists mm_wiki.mw_role_privilege purge;
create table mm_wiki."mw_role_privilege" (
  "role_privilege_id" int not null primary key identity(1,1) , --comment '角色权限关系 id',
  "role_id" int  not null default 0, --comment '角色id',
  "privilege_id" int  not null default 0, --comment '权限id',
  "create_time" int  not null default 0 --comment '创建时间',
) ;--, --comment='系统角色权限对应关系表';

-- --------------------------------
-- 空间表
-- --------------------------------
drop table if exists mm_wiki.mw_space purge;
create table mm_wiki."mw_space" (
  "space_id" int not null primary key identity(1,1) , --comment '空间 id',
  "name" varchar(50) not null default '', --comment '名称',
  "description" varchar(100) not null default '', --comment '描述',
  "tags" varchar(255) not null default '', --comment '标签',
  "visit_level" varchar(100) not null default 'public', --comment '访问级别：private,public',
  "is_share" tinyint not null default 1, --comment '文档是否允许分享 0 否 1 是',
  "is_export" tinyint not null default 1, --comment '文档是否允许导出 0 否 1 是',
  "is_delete" tinyint not null default 0, --comment '是否删除 0 否 1 是',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='空间表';

-- --------------------------------
-- 空间成员表
-- --------------------------------
drop table if exists mm_wiki.mw_space_user purge;
create table mm_wiki."mw_space_user" (
  "space_user_id" int not null primary key identity(1,1) , --comment '用户空间关系 id',
  "user_id" int not null default 0, --comment '用户 id',
  "space_id" int not null default 0, --comment '空间 id',
  "privilege" tinyint not null default 0, --comment '空间成员操作权限 0 浏览者 1 编辑者 2 管理员',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '修改时间',
) ;--, --comment='空间成员表';
create unique index idx_mw_space_user_user_id_space_id on mm_wiki."mw_space_user"("user_id", "space_id");
-- --------------------------------
-- 文档表
-- --------------------------------
drop table if exists mm_wiki.mw_document purge;
create table mm_wiki."mw_document" (
  "document_id" int not null primary key identity(1,1) , --comment '文档 id',
  "parent_id" int not null default 0, --comment '文档父 id',
  "space_id" int not null default 0, --comment '空间id',
  "name" varchar(150) not null default '', --comment '文档名称',
  "type" tinyint not null default 1, --comment '文档类型 1 page 2 dir',
  "path" varchar(30) not null default 0, --comment '存储根文档到父文档的 document_id 值, 格式 0,1,2,...',
  "sequence" int not null default 0, --comment '排序号(越小越靠前)',
  "create_user_id" int not null default 0, --comment '创建用户 id',
  "edit_user_id" int not null default 0, --comment '最后修改用户 id',
  "is_delete" tinyint not null default 0, --comment '是否删除 0 否 1 是',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='文档表';

-- --------------------------------
-- 用户收藏表
-- --------------------------------
drop table if exists mm_wiki.mw_collection purge;
create table mm_wiki."mw_collection" (
  "collection_id" int not null primary key identity(1,1) , --comment '用户收藏关系 id',
  "user_id" int not null default 0, --comment '用户id',
  "type" tinyint not null default 1, --comment '收藏类型 1 文档 2 空间',
  "resource_id" int not null default 0, --comment '收藏资源 id ',
  "create_time" bigint not null default 0 --comment '创建时间',
) ;--, --comment='用户收藏表';
create unique index idx_mw_collection on mm_wiki."mw_collection"("user_id", "resource_id", "type");
-- --------------------------------
-- 用户关注表
-- --------------------------------
drop table if exists mm_wiki.mw_follow purge;
create table mm_wiki.mw_follow (
  "follow_id" int not null primary key identity(1,1) , --comment '关注 id',
  "user_id" int not null default 0, --comment '用户id',
  "type" tinyint not null default 1, --comment '关注类型 1 文档 2 用户',
  "object_id" int not null default 0, --comment '关注对象 id',
  "create_time" bigint not null default 0 --comment '创建时间',
) ;--, --comment='用户关注表';
create unique index idx_mw_follow on mm_wiki.mw_follow(user_id, object_id, type);
-- --------------------------------
-- 文档日志表
-- --------------------------------
drop table if exists mm_wiki.mw_log_document purge;
create table mm_wiki."mw_log_document" (
  "log_document_id" int not null primary key identity(1,1) , --comment '文档日志 id',
  "document_id" int not null default 0, --comment '文档id',
  "space_id" int not null default 0, --comment '空间id',
  "user_id" int not null default 0, --comment '用户id',
  "action" tinyint not null default 1, --comment '动作 1 创建 2 修改 3 删除',
  "comments" varchar(255) not null default '', --comment '备注信息',
  "create_time" int  not null default 0 --comment '创建时间',
) ;--, --comment='文档日志表';

-- --------------------------------
-- 系统操作日志表
-- --------------------------------
drop table if exists mm_wiki.mw_log purge;
create table mm_wiki."mw_log" (
  "log_id" bigint not null primary key identity(1,1) , --comment '系统操作日志 id',
  "level" tinyint not null default '6', --comment '日志级别',
  "path" varchar(100) not null default '', --comment '请求路径',
  "get" varchar(4000) not null, --comment 'get参数',
  "post" varchar(4000) not null, --comment 'post参数',
  "message" varchar(255) not null default '', --comment '信息',
  "ip" varchar(100) not null default '', --comment 'ip地址',
  "user_agent" varchar(200) not null default '', --comment '用户代理',
  "referer" varchar(100) not null default '', --comment 'referer',
  "user_id" int not null default 0, --comment '用户id',
  "username" varchar(100) not null default '', --comment '用户名',
  "create_time" int  not null default 0 --comment '创建时间',
) ;--, --comment='系统操作日志表';

-- --------------------------------
-- 邮件服务器表
-- --------------------------------
drop table if exists mm_wiki.mw_email purge;
create table mm_wiki."mw_email" (
  "email_id" int  not null primary key identity(1,1) , --comment '邮箱 id',
  "name" varchar(100) not null default '', --comment '邮箱服务器名称',
  "sender_address" varchar(100) not null default '', --comment '发件人邮件地址',
  "sender_name" varchar(100) not null default '', --comment '发件人显示名',
  "sender_title_prefix" varchar(100) not null default '', --comment '发送邮件标题前缀',
  "host" varchar(100) not null default '', --comment '服务器主机名',
  "port" int not null default '25', --comment '服务器端口',
  "username" varchar(50) not null default '', --comment '用户名',
  "password" varchar(50) not null default '', --comment '密码',
  "is_ssl" tinyint not null default 0, --comment '是否使用ssl， 0 默认不使用 1 使用',
  "is_used" tinyint not null default 0, --comment '是否被使用， 0 默认不使用 1 使用',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='邮件服务器表';

-- --------------------------------
-- 快捷链接表
-- --------------------------------
drop table if exists mm_wiki.mw_link purge;
create table mm_wiki."mw_link" (
  "link_id" int  not null primary key identity(1,1) , --comment '链接 id',
  "name" varchar(50) not null default '', --comment '链接名称',
  "url" varchar(100) not null default '', --comment '链接地址',
  "sequence" int not null default 0, --comment '排序号(越小越靠前)',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='快捷链接表';

-- --------------------------------
-- 统一登录认证表
-- --------------------------------
drop table if exists mm_wiki.mw_login_auth purge;
create table mm_wiki."mw_login_auth" (
  "login_auth_id" bigint not null primary key identity(1,1) , --comment '认证表主键id',
  "name" varchar(30) not null, --comment '登录认证名称',
  "username_prefix" varchar(30) not null, --comment '用户名前缀',
  "url" varchar(200) not null, --comment '认证接口 url',
  "ext_data" varchar(500) not null default '', --comment '额外数据: token=aaa&key=bbb',
  "is_used" tinyint not null default 0, --comment '是否被使用， 0 默认不使用 1 使用',
  "is_delete" tinyint not null default 0, --comment '是否删除 0 否 1 是',
  "create_time" bigint not null, --comment '创建时间',
  "update_time" bigint not null --comment '更新时间',
) ;--, --comment='统一登录认证表';

-- --------------------------------
-- 全局配置表
-- --------------------------------
drop table if exists mm_wiki.mw_config purge;
create table mm_wiki."mw_config" (
  "config_id" bigint not null primary key identity(1,1) , --comment '配置表主键id',
  "name" varchar(100) not null default '', --comment '配置名称',
  "key" varchar(50) not null default '', --comment '配置键',
  "value" varchar(4000) not null, --comment '配置值',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='全局配置表';

-- --------------------------------
-- 系统联系人表
-- --------------------------------
drop table if exists mm_wiki.mw_contact purge;
create table mm_wiki."mw_contact" (
  "contact_id" int  not null primary key identity(1,1) , --comment '联系人 id',
  "name" varchar(50) not null default '', --comment '联系人名称',
  "mobile" varchar(13) not null default '', --comment '联系电话',
  "email" varchar(50) not null default '', --comment '邮箱',
  "position" varchar(100) not null default '', --comment '联系人职位',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='联系人表';


-- --------------------------------
-- 附件信息表
-- --------------------------------
drop table if exists mm_wiki.mw_attachment purge;
create table mm_wiki."mw_attachment" (
  "attachment_id" int  not null primary key identity(1,1) , --comment '附件 id',
  "user_id" int not null default 0, --comment '创建用户id',
  "document_id" int not null default 0, --comment '所属文档id',
  "name" varchar(50) not null default '', --comment '附件名称',
  "path" varchar(100) not null default '', --comment '附件路径',
  "source" tinyint not null default 0, --comment '附件来源， 0 默认是附件 1 图片',
  "create_time" bigint not null default 0, --comment '创建时间',
  "update_time" bigint not null default 0 --comment '更新时间',
) ;--, --comment='附件信息表';
