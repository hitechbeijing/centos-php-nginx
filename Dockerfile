FROM centos:7
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN curl -o /etc/yum.repos.d/CentOS7-Base-163.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo 
RUN yum install -y wget
RUN touch /etc/yum.repos.d/nginx.repo
RUN echo -e "[nginx-stable]\nname=nginx stable repo\nbaseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/\ngpgcheck=1\nenabled=1\ngpgkey=https://nginx.org/keys/nginx_signing.key" > /etc/yum.repos.d/nginx.repo
RUN yum clean all
RUN yum makecache
RUN yum install -y nginx
RUN yum install -y epel-release
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum install -y php71w-fpm php71w-mysql php71w-mbstring php71w-gd php71w-cli php71w-devel php71w-mcrypt php71w-pdo php71w-pecl-redis php71w-xml gcc gcc-c++ autoconf pcre-devel
RUN wget http://pecl.php.net/get/swoole-4.3.1.tgz
RUN tar -xzvf swoole-4.3.1.tgz
WORKDIR /swoole-4.3.1
RUN phpize
RUN ./configure
RUN make
RUN make install
RUN echo -e ";  Enable swoole extension module\nextension=swoole.so" > /etc/php.d/swoole.ini
WORKDIR /
RUN rm -rf swoole-4.3.1 swoole-4.3.1.tgz
RUN echo -e ":set encoding=utf-8\n\
:set fileencodings=ucs-bom,utf-8,cp936\n\
:set fileencoding=gbk\n\
:set termencoding=utf-8" > /root/.vimrc
RUN cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN yum install kde-l10n-Chinese -y
RUN yum install glibc-common -y
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LC_ALL zh_CN.UTF-8
RUN systemctl enable php-fpm.service
RUN systemctl enable nginx.service
