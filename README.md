**Baixando o dockerfile**

```bash
wget https://raw.githubusercontent.com/ferreirarocha/dockerglpi/master/Dockerfile
```



**Criando a imagem para o GLPI**

```bash
docker build -t ferreirarocha/glpi:9.2.2 .
```



**Criando volume para persistência dos dados do GLPI /var/www/html/**

```
sudo docker volume create wwwglpi
```

**Criando volume para persistência da configuração do banco de dados**

```bash
sudo docker volume create configdatabase
```



**Executando o container**

```bash
docker container run  --restart always --name glpiproducao -d -v wwwglpi:/var/www/html -v configdatabase:/etc/mysql/conf.d  -p 192.168.50.100:80:80 ferreirarocha/glpi:9.2.2
```



### **Informações sobre o container.**

 **--restart=always**  = Informa ao docker para executar o container sempre que o sistema operacional inicializar

**wwwglpi:/var/www/html** = Volume wwwglpi para o diretório /var/www/html no container

**configdatabase:/etc/mysql/conf.d** = Volume configdatabase para o diretório de configuraçao do banco de dados, optamos por não executar o banco de dados via docker, embora seja tecnicamente possível.

**ferreirarocha/glpi:9.2.2** Imagem criada via Dockerfile mantenedor ferreirarocha imagem glpi tag 9.2.2

**--it** = Cria um terminal virtual e interativo









## 