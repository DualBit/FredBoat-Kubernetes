apiVersion: apps/v1
kind: Deployment
metadata:
  name: fredboat-fredboat
  labels:
    app: fredboat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fredboat-fredboat
  template:
    metadata:
      labels:
        app: fredboat-fredboat
    spec:
      initContainers:
        - name: init-wait-postgres
          image: alpine
          command: ["sh", "-c", "for i in $(seq 1 300); do nc -zvw1 fredboat-postgres-service {{ POSTGRES_PORT }} && exit 0 || sleep 3; done; exit 1"]
        - name: init-wait-rabbitmq
          image: alpine
          command: ["sh", "-c", "for i in $(seq 1 300); do nc -zvw1 fredboat-rabbitmq-service 5672 && exit 0 || sleep 3; done; exit 1"]
        - name: init-wait-quarterdeck
          image: alpine
          command: ["sh", "-c", "for i in $(seq 1 300); do nc -zvw1 fredboat-quarterdeck-service {{ QUARTERDECK_PORT }} && exit 0 || sleep 3; done; exit 1"]
      containers:
        - name: fredboat-fredboat
          image: fredboat/fredboat:dev-v4
          imagePullPolicy: Always
          ports:
            - containerPort: {{ FREDBOAT_PORT }}
          env:
            - name: SPRING_RABBITMQ_ADDRESSES
              value: amqp://guest:guest@fredboat-rabbitmq-service
          volumeMounts:
          - name: fredboat-configmap-volume
            mountPath: /opt/FredBoat/fredboat.yml
            subPath: fredboat.yml
            readOnly: true
          - name: fredboat-configmap-volume
            mountPath: /opt/FredBoat/common.yml
            subPath: common.yml
            readOnly: true
      volumes:
      - name: fredboat-configmap-volume
        configMap:
          name: fredboat-configmap
