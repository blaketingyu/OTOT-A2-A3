echo A3 Stress Test
echo ==========================

kubectl describe hpa --context kind-kind-l

while true; clear; do kubectl describe hpa;sleep 5; done

curl "localhost/?[0-4999]" --parallel --parallel-max 100 --no-progress-meter > /dev/null


kubectl describe hpa --context kind-kind-1

echo Stress Test ended!
