apiVersion: apps/v1
kind: Deployment
metadata:
  name: fredboat-postgres
  labels:
    app: fredboat
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fredboat-postgres
  template:
    metadata:
      labels:
        app: fredboat-postgres
    spec:
      containers:
        - name: fredboat-postgres
          image: fredboat/postgres:latest
          imagePullPolicy: Always
          ports:
            - containerPort: {{ POSTGRES_PORT }}
          env:
            - name: POSTGRES_USER
              value: {{ POSTGRES_USER }}
            - name: POSTGRES_PASSWORD
              value: {{ POSTGRES_PASSWORD }}
            - name: POSTGRES_DB
              value: fredboat
            - name: PGDATA
              value: /var/lib/postgresql/data/pgdata
          volumeMounts:
          - name: fredboat-postgres-volume-mount
            mountPath: /var/lib/postgresql/data
      volumes:
      - name: fredboat-postgres-volume-mount
        persistentVolumeClaim:
          claimName: fredboat-postgres-pvc
