#!/bin/bash


TARGET="house_price_predict"
VERSION="1.0.0"

FLASK_PROT=5000


REPO_URL="105372338271.dkr.ecr.us-east-1.amazonaws.com/house_price_predict"

 
USAGE="

USAGE: $(basename "$0") start|START port 8010  8011 ... 
       $(basename "$0") build|BUILD
       $(basename "$0") stop|STOP
       $(basename "$0") load|LOAD
       $(basename "$0") save|SAVE
       $(basename "$0") push|PUSH
       $(basename "$0") pull|PULL
where:
   start|START    start component, followd by ports  
   build|BUILD    build component
   stop|STOP      stop component
   load|LOAD      load image to local repository
   save|SAVE      save component to image
   push|PUSH      push image to remote repository
   pull|PULL      push image from remote repository
"


build_image(){

   if [  -d "./requirement.txt" ];then
   rm ./requirement.txt
   fi

   if [  -d "./server" ];then
   rm -r ./server
   fi
 
   cp ../requirement.txt . 
   cp -rf ../server . 
   cp -rf ../model . 
   
   sudo docker build . -t "$TARGET":"$VERSION" --network host
   
   rm -rf ./server
   rm -rf ./model
}


for i in "$@" 
do
   key="$1"
   case $key in
      build|BUILD )
      shift
      op="build"
      ;;
      start|START )
      shift
      op="start"
      #shift
      PORT=$@
      break
      ;;
      stop|STOP )
      shift
      op="stop"
      ;;
      load|LOAD )
      shift
      op="load"
      ;;
      save|SAVE )
      shift
      op="save"
      ;;
      push|PUSH )
      shift
      op="push"
      ;;
      pull|PULL )
      shift
      op="pull"
      ;;
      -h|--help )
      echo "$USAGE"
      exit
      ;;
      * )
      echo "$USAGE"
      exit 1
   esac
done


IMAGES_ID=$(sudo docker images | grep "$TARGET" | grep "$VERSION" |  awk '{print $3}')
REPO_REGION=$(echo $REPO_URL |  awk -F . '{print $4}')

if [[ $op == "build" ]]; then
   echo "*** BUILD IMAGE "
   build_image 
elif [[ $op == "start" ]]; then
   echo "*** STARTING "
   for var in $PORT
   do
      sudo docker run -d -p "$var":"$FLASK_PROT" \
      -t "$TARGET":"$VERSION"
   done
elif [[ $op == "load" ]]; then
   echo "*** LOADING "
   sudo docker load -i "$TARGET"_"$VERSION".tar.gz
elif [[ $op == "push" ]]; then
   echo "*** PUSHING "
   aws ecr get-login-password --region $REPO_REGION | sudo docker login --username AWS --password-stdin $REPO_URL
   sudo docker tag $IMAGES_ID $REPO_URL:$VERSION
   sudo docker push $REPO_URL:$VERSION
elif [[ $op == "pull" ]]; then
   echo "*** PULLING "
   aws ecr get-login-password --region $REPO_REGION | sudo docker login --username AWS --password-stdin $REPO_URL
   sudo docker pull $REPO_URL:$VERSION
elif [[ $op == "stop" ]]; then
   echo "*** STOPING "
   container=$(sudo docker ps | grep "$TARGET":"$VERSION" | cut -d " " -f1)
   sudo docker stop $container
   sudo docker rm $container
elif [[ $op == "save" ]]; then
   echo "*** SAVING IMAGE"
   sudo docker save "$TARGET":"$VERSION" | gzip -c  > "$TARGET"_"$VERSION".tar.gz
else
   echo "Unknow argument...."
fi



exit 0

 














