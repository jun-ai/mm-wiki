docker rm -f mm-wiki

sleep 1

docker run -d -p 8080:8081 \
        -v $PWD/conf/mm-wiki.conf:/opt/mm-wiki/conf/mm-wiki.conf \
        -v $PWD/data:/opt/mm-wiki/data \
        -v $PWD/static:/opt/mm-wiki/static \
        -v $PWD/views:/opt/mm-wiki/views \
        --name mm-wiki mmwiki:latest
