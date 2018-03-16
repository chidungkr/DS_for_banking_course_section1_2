

#=================================
#   Cấu trúc và kiểu dữ liệu
#=================================


#----------------------------------------------
#  Vector - đơn vị cơ bản nhất lưu trữ dữ liệu
#  và kiểu dữ liệu
#----------------------------------------------

# Một vector kí tự (character): 

branch_name <- c("HN", "HP", "SG", "CT") 
str(branch_name)
class(branch_name)

# Một vector số: 

sales <- c(230, 97.5, 170, 70)
str(sales)
class(sales)

# Một vector có dữ liệu trống: 
profit <- c(30, 15.4, NA, 13)
str(profit)
class(profit)

# Một vector số nguyên: 

staffs <- c(87L, 50L, 70L, 40L)
str(staffs)
class(staffs)

# Một vector logic: 

int_payment <- c(TRUE, TRUE, TRUE, FALSE)
str(int_payment)
class(int_payment)

# Một vector factor: 

gender_manager <- factor(c("male", "female", "female", "male"))
str(gender_manager)
class(gender_manager)

#--------------------------------------------------------
#  Phạm vi áp dụng ác phép toán (hàm) có thể áp dụng cho 
# từng loại dữ liệu khác nhau là khác nhau
#--------------------------------------------------------

# Có thể áp dụng các tính toán thông thường và hàm thống kê cho vector số: 

sales - 100
100*sales
mean(sales)
sd(sales)

# Lưu ý về kết quả của việc áp dụng hàm đối với các vector có NA: 

mean(profit)
mean(profit, na.rm = TRUE)

# Lưu ý về phạm vi áp dụng của các hàm đối với từng loại / kiểu dữ liệu. 
# Có hàm áp dụng được cho kiểu dữ liệu A nhưng không áp dụng được cho 
# kiểu dữ liệu B: 

sd(sales)
sd(gender_manager)

# Nhưng có một số hàm có thể áp dụng cho nhiều kiểu dữ liệu: 
table(sales)
table(gender_manager)

# Với kiểu dữ liệu Logical thì có một số tính chất đặc biệt: 

sum(int_payment)
TRUE*int_payment
FALSE*int_payment

#-----------------------------------------
#  Truy cập vào từng phần tử của vector
#-----------------------------------------

# Cách 1 (theo vị trí):  

sales[1]
branch_name[3]

# Cách 2 (theo giá trị Logic): 

sales[c(TRUE, FALSE, FALSE, FALSE)]
branch_name[c(FALSE, FALSE, TRUE, FALSE)]

# Giữa hai cách thức này có một mối liên hệ tinh tế: 
sales[sales > 150]

# Nghĩa là ta có thể tính số lượng chi nhánh có sales lớn hơn 150: 
sum(sales > 150)


#-----------------------------------------------
#  Quy ước về đặt tên và chính tả (xem slide)
#-----------------------------------------------


#--------------------------------------
#  Data Frame - cấu trúc dữ liệu phổ 
#  biến được tạo ra từ các nguyên tử 
#  cơ bản là vector
#--------------------------------------

# Tạo ra DF một cách thủ công: 


df1 <- data.frame(nh = branch_name, 
                  gender_head = gender_manager, 
                  int_service = int_payment, 
                  loi_nhuan = profit, 
                  doanh_thu = sales, 
                  n_nhan_vien = staffs)



# Điều tra sơ bộ về DF: 
class(df1)
str(df1)
dim(df1)
nrow(df1)
ncol(df1)
summary(df1)
head(df1)
tail(df1)


# Truy cập vào từng phần tử của một DF: 
df1$n_nhan_vien # Lấy ra một cột của DF. 
df1[1, 4] # Lấy ra phần tử ở hàng 1 cột 4. 

a <- df1$n_nhan_vien
sum(a)
sum(staffs)

# Data Frame có thể tạo ra từ chính các dữ liệu sẵn có của R: 

data("iris")
df2 <- iris
head(df2)
dim(df2)

# Hoặc được tạo ra bằng đọc dữ liệu, ví dụ, một phần mềm 
# hay cơ sở quản trị dữ liệu nào đó vào R: 

german <- read.csv("D:/Teaching/new_data/german_credit.csv")
class(german)
head(german)


#---------------------------------------------
#  List - một kiểu cấu trúc - tổ chức quản lí 
#  dữ liệu phức tạp hơn
#---------------------------------------------

# Tạo ra list: 

list1 <- list(df1, df2, staffs)
sapply(list1, summary)

# Truy cập vào từng phần tử của list: 

list1[[1]]
list1[[3]]

#======================
#  Toán tử pipe (%>%)
#======================

library(magrittr)

# Truyền thống: 
mean(sales)
sd(sales)

# Toán tử Pipe: 

sales %>% mean()
sales %>% sd()

sales %>% sd() %>% sqrt()

# Một tình huống khác: 
a <- df1$n_nhan_vien
sum(a)

df1$n_nhan_vien %>% sum()

#========================================
#   Đọc nhiều file dữ liệu cùng một lúc
#========================================

# Thiết lập đường dẫn đến các files cần đọc: 

my_files <- dir("D:/Teaching/data_science_banking/data_vis_wrangling/201711", full.names = TRUE)
my_files

library(readxl)

# Đọc dữ liệu vào R (tồn tại ở dạng list): 
data_list <- lapply(my_files, read_excel)
sapply(data_list, dim)
sapply(data_list, summary)
sapply(data_list, names)

# Chuyển hóa về Data Frame quen thuộc: 

library(tidyverse)
library(magrittr)
data_df <- do.call("bind_rows", data_list)


#====================================
#  Đọc dữ liệu từ một cơ sở dữ liệu
#====================================

# loads the PostgreSQL driver: 
library("RPostgreSQL")
drv <- dbDriver("PostgreSQL")

# Creates a connection to the postgres database. Note that "con" 
# will be used later in each connection to the database: 

con <- dbConnect(drv, 
                 dbname = "db_bamboo",
                 host = "test.gfd.com.vn", 
                 port = 5432,
                 user = "dungtiensinh", 
                 password = "12@45")


# Check for the cartable: 
dbExistsTable(con, "tbl_points")

# Import data from data base: 
df_postgres <- dbGetQuery(con, "SELECT * from tbl_points")

# Close the connection: 
dbDisconnect(con)

# Inspect our data: 

df_postgres %>% head()
df_postgres %>% dim()
df_postgres %>% names()
df_postgres$country %>% table()


#============================================
#    Dữ liệu kích thước lớn và cách xử lí
#============================================

# Đọc theo các thông thường: 
c1 <- read.csv("D:/Teaching/data_science_banking/data_vis_wrangling/porn/xhamster.csv")
c1 %>% dim()

# Đo thời gian: 

system.time(
  c1 <- read.csv("D:/Teaching/data_science_banking/data_vis_wrangling/porn/xhamster.csv")
)

# Đọc dữ liệu bằng hàm read_csv(): 

system.time(
  c2 <- read_csv("D:/Teaching/data_science_banking/data_vis_wrangling/porn/xhamster.csv")
)

# Đọc dữ liệu bằng hàm fread(): 

library(data.table)

system.time(
  c3 <- fread("D:/Teaching/data_science_banking/data_vis_wrangling/porn/xhamster.csv")
)

# Kích thước của dữ liệu: 
library(pryr)
object_size(c1)
object_size(c2)
object_size(c3)


#===========================================
#  Programming and writting R functions
#===========================================

#------------------
#     1. Mean
#------------------


# Function for calculating mean: 

tinh_mean <- function(x) {
  n <- length(x)
  tong <- sum(x)
  tb <- tong / n
  return(tb)
}

# Testing: 

x <- c(1, 2, 4, 1)
tinh_mean(x) # self-written function
mean(x) # R base function. 

# Explanation: 

n <- length(x)
n
tong <- sum(x)
tong
tb <- tong / n
tb

#  Function for calculating area: 

tinh_dien_tich <- function(a, b) {
  s <- a*b
  return(s)
}

# Testing: 

tinh_dien_tich(a = 2, b = 4.53)
#---------------------------------------------------
#  2. Standard Deviation
#  https://en.wikipedia.org/wiki/Standard_deviation
#---------------------------------------------------

# Function for calculating SD: 

lech_chuan <- function(x) {
  tb <- mean(x)
  ts <- sum((x - tb)^2)
  ms <- length(x) - 1
  lc <- sqrt(ts / ms)
  return(lc)
}

# Testing: 

lech_chuan(x) # Our Function
sd(x) # R base Function


#----------------------------------------
#  3. Median
#  https://en.wikipedia.org/wiki/Median
#----------------------------------------

# A function for calculating median: 

my_median <- function(x) {
  x <- x[order(x)]
  a <- length(x) %% 2
  if (a == 1) 
    med <- x[(length(x) %/% 2) + 1]
  if (a == 0)
    med <- 0.5*(x[length(x) / 2] + x[(length(x) / 2) + 1])
  return(med)
}

# Testing: 

my_median(trees$Girth[1:10])
median(trees$Girth[1:10])

my_median(trees$Girth[1:9])
median(trees$Girth[1:9])

#-----------------------------
#  For Loop: An Application
#-----------------------------

# Tính trung bình của ba biến số một cách lần lượt: 

cot_thu_i <- trees[, 1]
cot_thu_i %>% tinh_mean()

cot_thu_i <- trees[, 2]
cot_thu_i %>% tinh_mean()

cot_thu_i <- trees[, 3]
cot_thu_i %>% tinh_mean()

# Giải pháp 1 (chưa tốt): 

for (i in 1:3) {
  cot_thu_i <- trees[, i]
  tb <- cot_thu_i %>% tinh_mean()
}

# Giải pháp 2 (tốt hơn): 

tb_cac_cot <- c()

for (i in 1:3) {
  cot_thu_i <- trees[, i]
  tb <- cot_thu_i %>% tinh_mean()
  tb_cac_cot <- c(tb_cac_cot, tb)
}


tb_cac_cot

# Giải pháp 3 (tốt hơn nữa): 

sapply(trees, tinh_mean)

# Giải pháp 4 (tốt nhất): 

trees %>% summarise_all(tinh_mean)


#-------------------------------------------
#   4. Skewness
#   https://en.wikipedia.org/wiki/Skewness 
#-------------------------------------------

# Function for calculating Skewness: 

my_skew <- function(x) {
  # Calculating m: 
  tb <- mean(x)
  u <- (x - tb)^3
  m <- mean(u)
  # Calculating s: 
  s <- sd(x)
  # Final step: 
  b <- m / s^3
  return(b)
}

# Testing: 
my_skew(x) # Our function. 

library(psych)
skew(x) # A psych's function.  

#------------------------------------------------------------------
#  5. Kurtosis
#  http://www.itl.nist.gov/div898/handbook/eda/section3/eda35b.htm
#------------------------------------------------------------------

# A function for calculating kurtosis: 

my_kurt <- function(x) {
  n <- length(x)
  x <- x - mean(x)
  r <- n*sum(x^4)/(sum(x^2)^2)
  y <-  r*(1 - 1/n)^2 - 3
  return(y)
}


# Testing: 
my_kurt(x) # Own Function. 
kurtosi(x) # A psych's function. 

#=================================================
#  Xử lí kí tự kiểu kí tự (chring / character)
#=================================================


#-----------------------------
#  Case 1: Dữ liệu của Quỳnh
#-----------------------------

data_df %>% glimpse()

# Viết hàm lấy ra thông tin về loại giao dịch: 
id <- data_df$ID[1:10]
library(stringr)
str_count("GLSCB.MVT-0005-")

id %>% str_sub(start = 16, end = 18)

# Triển khai thành hàm như sau (chưa tốt): 

ngoai_te_giao_dich <- function(s) {
  s %>% 
    str_sub(start = 16, end = 18)
}

# Tốt hơn: 

ngoai_te_giao_dich <- function(s) {
  s %>% 
    str_sub(start = 16, end = 18) %>% 
    return()
}


# Test hàm: 
ngoai_te_giao_dich(id)

# Áp dụng hàm này: 
data_df %<>% mutate(loai_tien = ngoai_te_giao_dich(ID))

# Yêu cầu học viên tự viết hàm lấy ra thông tin về: 
#  - Ngày giao dịch. 
#  - Tháng giao dịch.
#  - Năm cùa giao dịch
#  - Số tài khoản của giao dịch. 


# Thách thức 1: Viết hàm tạo ra cột biến có bản chất thời gian 
# và hình ảnh hóa số lượng giao dịch theo thời gian. 


str_replace_all(id, "B", "")
id %>% str_replace_all("B", "")
str_replace_all(id, "A|B", "")
id %>% str_replace_all("A|B", "")

id %>% str_replace_all("[A-Z]", "")
id %>% str_replace_all("[^0-9]", "")

data_df$TENCN %>% str_detect("PGD") %>% sum()
data_df %>% nrow()

# Hàm lấy ra năm (phương án 1): 

nam_giao_dich <- function(x) {
  x %>% 
    str_sub(20, 23) %>% 
    return()
}

id %>% nam_giao_dich()

# Hàm lấy ra tháng giao dịch: 

thang_giao_dich <- function(x) {
  x %>% 
    str_sub(24, 25) %>% 
    return()
}

id %>% thang_giao_dich()

# Hàm lấy ra ngày giao dịch 
ngay_giao_dich <- function(x) {
  x %>% 
    str_sub(26, 27) %>% 
    return()
}

id %>% ngay_giao_dich()

# Áp dụng hàm: 
data_df %<>% mutate(nam = nam_giao_dich(ID), 
                    thang = thang_giao_dich(ID), 
                    ngay = ngay_giao_dich(ID))

# Viết ra hàm tạo biến thời gian thực: 

real_time <- function(x) {
  x %>% 
    str_sub(20, 27) %>% 
    ymd() %>% 
    return()
}

# Áp dụng hàm: 
data_df %<>% mutate(time_ymd = real_time(ID))

data_df$time_ymd %>% range()

data_df %>% 
  group_by(time_ymd) %>% 
  count() %>% 
  ggplot(aes(time_ymd, n)) + 
  geom_line() + 
  geom_point(color = "red")

# Viết hàm tạo weekday: 

w_day <- function(x) {
  x %>% 
    lubridate::wday(abbr = TRUE, label = TRUE) %>% 
    return()
  
}

# Sử dụng hàm: 

data_df %<>% mutate(w_d = w_day(time_ymd))

data_df %>% 
  group_by(w_d) %>% 
  count() %>% 
  ggplot(aes(w_d, n)) + 
  geom_col()

# Viết hàm lấy ra thông tin về người phụ trách giao dịch: 
tran_head <- function(x) {
  ELSE <- TRUE
  case_when(x %>% str_detect("PGD") ~ "Vice President", 
            ELSE ~ "Staff")
}

# Áp dụng hàm: 

data_df %<>% 
  mutate(vice_presi = tran_head(TENCN))

data_df %>% 
  group_by(vice_presi) %>% 
  count() %>% 
  ggplot(aes(vice_presi, n)) + 
  geom_col()

# (Chỉ cho học viên hiểu về outliers và vai trò của phân tích hình ảnh): 
data_df %>% 
  ggplot(aes(vice_presi, PS.CO)) + 
  geom_boxplot() + 
  facet_wrap(~ vice_presi, scales = "free")

data_df %>% 
  na.omit() %>% 
  group_by(vice_presi) %>% 
  summarise_each(funs(mean, median, min, max, sd), PS.CO)

#--------------------------------------------
#   Case 1: Porn Data (trình bày tại lớp)
#--------------------------------------------


#--------------------------------------------
#   Case 2: Giáo sư 2017 (Trình bày tại lớp)
#--------------------------------------------



