apiVersion: apps/v1
kind: Deployment
metadata:
  name: fredboat-lavalink
  labels:
    app: fredboat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fredboat-lavalink
  template:
    metadata:
      labels:
        app: fredboat-lavalink
    spec:
      containers:
        - name: fredboat-lavalink
          image: fredboat/lavalink:master
          imagePullPolicy: Always
          ports:
            - containerPort: {{ LAVALINK_PORT }}
          volumeMounts:
          - name: fredboat-configmap-volume
            mountPath: /opt/Lavalink/application.yaml
            subPath: application.yml
            readOnly: true
      volumes:
      - name: fredboat-configmap-volume
        configMap:
          name: fredboat-configmap
