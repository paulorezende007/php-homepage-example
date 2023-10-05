for ((i=1;i<=10000;i++)); do
  curl -s -o /dev/null -w "Requisicao-$i: Status %{http_code}" 'http://34.149.12.219/';
  echo ""
done

while true; do sleep 1; curl http://www.google.com; echo -e '\n\n\n\n'$(date);done




import time
from locust import HttpUser, task, between

class HelloWorldUser(HttpUser):
    @task
    def hello_world(self):
        self.client.get("/")