# Python SSH SSL SNI Injector For Free Internet [HTTP Injector]

<p align="center">
   <a href="#installation">Installation & Usage</a>
   &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
   <a href="#introduction">Introduction</a>
</p>

## Introduction

### What is SNI?

[***Server Name Indication (SNI)***](https://en.wikipedia.org/wiki/Server_Name_Indication) is an extension to the Transport Layer Security (TLS) computer networking protocol by which a client indicates which hostname it is attempting to connect to at the start of the handshaking process.This allows a server to present one of multiple possible certificates on the same IP address and TCP port number and hence allows multiple secure (HTTPS) websites (or any other service over TLS) to be served by the same IP address without requiring all those sites to use the same certificate [<sup>Read more</sup>](https://en.wikipedia.org/wiki/Server_Name_Indication)

Here's a screenshot of **Wireshark** while I'm attempting to connect to zoom.us via https.
<img src="https://github.com/miyurudassanayake/sni-injector/blob/master/static/wireshark.png" width="70%"><br>
As you can see, I applied the <code>ssl.handshake.extensions server name=zoom.us</code> filter to wireshark to filter ssl handshakes where sni is <code>zoom.us</code>.

### What is SNI BUG Host

SNI bug hosts can be in various forms. They can be a packet host, a free CDN host, government portals, zero-rated websites, social media (subscription), and a variety of other sites. They also do a fantastic job of getting over your Internet service provider's firewall.

If you have a subscription to <code>zoom.us</code> and want to visit Zoom, your ISP's firewall will scan every time your SSL handshake to determine if the SNI is "zoom.us", and if it does, the firewall will enable you to keep that connection free fo charge. When you have a subscription to access internet, this is what happens.

What if we can modify our SNI and gain access to different sites? Yes! we can. However, SNI verification will fail, and the connection will be terminated by host. But we still can use ***our own TLS connection(with changed SNI) and use a proxy through it access the internet.***

*Here's a simple diagram showing how it's done.*<br>
<img src="https://github.com/miyurudassanayake/sni-injector/blob/master/static/zoom.us.png" width=50%>

### And here's how is it done

To do so, we need to install a proxy on our server and enable TLS encryption. We can use an SSH tunnel to access a proxy that is already installed on the server. And stunnel can be used to add TLS encryption to that connection.
<img src="https://github.com/miyurudassanayake/sni-injector/blob/master/static/stunnel.png" width="80%">



# Linux
## Server Side
1. **Open Ports** :
   - Ensure that ports `22` and `443` are open on your server.

2. **Install `stunnel`** :
   ```bash
   sudo apt-get install stunnel4 -y
   ```
3. **Create `stunnel.conf` File** 
   - Navigate to the `/etc/stunnel` directory and create the `stunnel.conf` file :
   ```bash
   sudo nano /etc/stunnel/stunnel.conf
   ```
4. **Edit `stunnel.conf`**
   - Add the following configuration to `stunnel.conf` :
   ```makefile
   client = no
   [stunnel]
   accept = 443
   connect = 127.0.0.1:22
   cert = /etc/stunnel/stunnel.pem
   ```
5. **Create SSL Certificates** :
   - Generate an SSL certificate file (`stunnel.pem`) and place it in the `/etc/stunnel `directory.
   ```bash
   openssl genrsa -out key.pem 2048
   openssl req -new -x509 -key key.pem -out cert.pem -days 1095
   cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
   ```
6. **Restart `stunnel`** :
   ```bash
   /etc/init.d/stunnel4 restart
   ```
   Source : <a href="https://www.digitalocean.com/community/tutorials/how-to-set-up-an-ssl-tunnel-using-stunnel-on-ubuntu" target="_blank">How To Set Up an SSL Tunnel Using Stunnel</a>
## Client Side 

1. **Clone the repository** :
   ```bash
   git clone https://github.com/kirula0626/sni-injector.git
   ```
2. **Add your SNI host and ssh host to `settings.ini`** : 
   ```bash
   [ssh]
   #Host must be your Server Public IP address
   #example host = 10.29.22.33
   host = [SERVER_PUBLIC_IP]

   [sni]
   #example server_name = facebook.com
   server_name = <SNI>
   ```
3. **Install the Requirements** :
   - To Requirements need `python` and `pip`
   ```bash
   pip install -r requirements.txt
   ```
4. **Edit the `ssh.sh` Script** :
   - Auto login and manual login. Uncomment wanted method.
```makefile
   #-Auto login with password
   #sshpass -p [SERVER_SSH_PASSWORD] ssh -C -o "ProxyCommand=nc -X CONNECT -x 127.0.0.1:9092 %h %p" [SERVER_USERNAME]@[SERVER_PUBLIC_IP] -p 443 -v -CND 1080 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
   #-Manual login
   #ssh -C -o "ProxyCommand=nc -X CONNECT -x 127.0.0.1:9092 %h %p" [SERVER_USERNAME]@[SERVER_PUBLIC_IP] -p 443 -CND 1080 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
   ```
   - For Auto login need `sshpass` tool :
   ```bash
   apt-get install sshpass
   ```
5. **Run `ssh.sh`script**
6. **Install `Proxychains`** :
   ```bash
   apt-get install proxychains4
   ```
   - Edit `proxychains` conf file :
   ```bash
   sudo nano /etc/proxychains4.conf
   ```
   - At the end, add this line  : 
   ```makefile
   socks5  127.0.0.1 1080
   ```
7. **Check `Proxychains`** :
   ```bash
   proxychains4 curl ifconfig.me
   ```
   - output must be Public Server IP
8. **Use** :
   1. Active proxy on Browser : Add SOCKS Host : `127.0.0.1` Port : `1080` and Select `SOCKSv5` 
   
   or
 
   2. Open using `proxychains4` : 
   ```bash
   proxychains4 firefox
   ```

