FROM nginx:alpine

# Remover versao do nginx nos headers (seguranca)
RUN sed -i 's/# server_tokens off;/server_tokens off;/g' /etc/nginx/nginx.conf || \
    echo "server_tokens off;" >> /etc/nginx/nginx.conf

# Copiar configuracao customizada do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar arquivos do site
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
COPY images/ /usr/share/nginx/html/images/

# Arquivos de SEO
COPY robots.txt /usr/share/nginx/html/
COPY sitemap.xml /usr/share/nginx/html/

# Definir permissoes corretas
RUN chmod -R 755 /usr/share/nginx/html && \
    chown -R nginx:nginx /usr/share/nginx/html

# Expor porta 24624
EXPOSE 24624

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:24624/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
