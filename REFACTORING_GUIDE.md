# 代码重构说明

## 已完成的工作

### 1. Service层创建完成
已创建以下Service接口和实现类：
- `UserService` / `UserServiceImpl`
- `ArticleService` / `ArticleServiceImpl`
- `CommentService` / `CommentServiceImpl`
- `FolderService` / `FolderServiceImpl`
- `TagService` / `TagServiceImpl`
- `FavoriteItemService` / `FavoriteItemServiceImpl`

### 2. 已修改的文件
- `LoginServlet` - 已改为使用 `UserService`
- `AutoLoginFilter` - 已改为使用 `UserService`

## 需要修改的Servlet文件

### 用户相关 (user包)
- `RegisterServlet` - 使用 `UserService`
- `UpdateUserInfoServlet` - 使用 `UserService`
- `UserProfileServlet` - 使用 `UserService`, `CommentService`, `FavoriteItemService`
- `UserStatsServlet` - 使用 `ArticleService`, `CommentService`, `FavoriteItemService`
- `MyArticlesServlet` - 使用 `ArticleService`
- `MyCollectServlet` - 使用 `FolderService`
- `MyInformationServlet` - 使用 `UserService`
- `AvatarUploadServlet` - 使用 `UserService`
- `UserPageServlet` - 使用 `UserService`, `ArticleService`

### 文章相关 (article包)
- `ArticlePublishServlet` - 使用 `ArticleService`, `TagService`
- `ArticleSaveDraftServlet` - 使用 `ArticleService`
- `ArticleDetailServlet` - 使用 `ArticleService`
- `ArticleListServlet` - 使用 `ArticleService`
- `ArticlePageServlet` - 使用 `ArticleService`
- `ArticleLikeServlet` - 使用 `ArticleService`
- `CheckLikeServlet` - 使用 `ArticleService`
- `HomeServlet` - 使用 `ArticleService`
- `DraftListServlet` - 使用 `ArticleService`
- `MyArticlesServlet` - 使用 `ArticleService`
- `ArticleDeleteServlet` - 使用 `ArticleService`
- `ArticleTogglePrivacyServlet` - 使用 `ArticleService`

### 评论相关 (commont包)
- `CommentServlet` - 使用 `CommentService`

### 收藏夹相关 (folder包)
- `CreateFolderServlet` - 使用 `FolderService`
- `FolderListServlet` - 使用 `FolderService`
- `AddToFolderServlet` - 使用 `FavoriteItemService`
- `RemoveFromFolderServlet` - 使用 `FavoriteItemService`
- `CheckFavoriteServlet` - 使用 `FavoriteItemService`
- `FolderNewServlet` - 无需修改（只是转发）

### 搜索相关 (search包)
- `SearchServlet` - 使用 `ArticleService`

## 修改模式

### 步骤1: 修改import语句
```java
// 旧代码
import com.blog.dao.UserDAO;
private UserDAO userDAO = new UserDAO();

// 新代码
import com.blog.service.UserService;
import com.blog.service.impl.UserServiceImpl;
private UserService userService = new UserServiceImpl();
```

### 步骤2: 修改方法调用
```java
// 旧代码
User user = userDAO.getUserById(id);

// 新代码
User user = userService.getUserById(id);
```

### 步骤3: 对于ArticleDAO中的常量
```java
// 旧代码
import com.blog.dao.ArticleDAO;
ArticleDAO.STATUS_PUBLISHED

// 新代码
import com.blog.service.ArticleService;
ArticleService.STATUS_PUBLISHED
```

## 注意事项

1. **保持功能不变**: 所有业务逻辑保持不变，只是将DAO调用改为Service调用
2. **字段不变**: 数据库字段和实体类字段都不变
3. **Service层职责**: Service层目前只是简单委托给DAO，未来可以在这里添加业务逻辑
4. **测试**: 修改后需要测试所有功能确保正常工作

## 快速修改脚本

可以使用IDE的全局替换功能：
1. 查找: `import com.blog.dao.(\w+)DAO;`
2. 替换: `import com.blog.service.$1Service;` 和 `import com.blog.service.impl.$1ServiceImpl;`
3. 查找: `private (\w+)DAO (\w+)DAO = new (\w+)DAO\(\);`
4. 替换: `private $1Service $2Service = new $1ServiceImpl();`
5. 查找: `(\w+)DAO\.`
6. 替换: `$1Service.`

然后手动检查每个文件确保正确。

