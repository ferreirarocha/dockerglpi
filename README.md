Baixando o dockerfile

```
wget https://raw.githubusercontent.com/ferreirarocha/dockerglpi/master/Dockerfile
```



**Criando a imagem para o GLPI**

```
docker build -t ferreirarocha/glpi:9.2.2 .
```



**Criando volume para persistência dos dados do GLPI /var/www/html/**

```
sudo docker volume create wwwglpi
```

**Criando volume para persistência da configuração do banco de dados**

```
sudo docker volume create configdatabase
```



**Criando uma rede para trabalhar com ips fixos, não é obrigatório**

```
docker network create --subnet=172.20.0.0/16 operacao
```

**Executando o container**

```
docker container run -it --restart=always --name glpiproducao -d -v wwwglpi:/var/www/html -v configdatabase:/etc/mysql/conf.d --net operacao --ip 172.20.0.22 ferreirarocha/glpi:9.2.2

```



### **Informações sobre o container.**

 **--restart=always**  = Informa ao docker para executar o container sempre que o sistema operacional inicializar

**wwwglpi:/var/www/html** = Volume wwwglpi para o diretório /var/www/html no container

**configdatabase:/etc/mysql/conf.d** = Volume configdatabase para o diretório de configuraçao do banco de dados, optamos por não executar o banco de dados via docker, embora seja tecnicamente possível.

**--net operacao --ip 172.18.0.22** = Define um ip fixo para o container.

**netprodução** = Rede criada pra  trabalhamos com assinaturas de IPs

**ferreirarocha/glpi:9.2.2** Imagem criada via Dockerfile mantenedor ferreirarocha imagem glpi tag 9.2.2

**--it** = Cria um terminal virtual e interativo









## 