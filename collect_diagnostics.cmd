@echo off
SETLOCAL

SET NAMESPACE=microservices
SET OUTPUT_FILE=%USERPROFILE%\Desktop\cognitive_service_diagnostics.txt
SET POD1=cognitive-service-app-5bf89cfdf7-fm94n
SET POD2=cognitive-service-app-5bf89cfdf7-txlnc
SET POD3=cognitive-service-app-5bf89cfdf7-zlvrv
SET NODE1=ip-10-44-220-84.ec2.internal
SET NODE2=ip-10-44-239-197.ec2.internal
SET NODE3=ip-10-44-197-102.ec2.internal

:: Clear or create output file
echo. > "%OUTPUT_FILE%"

echo ============================================================ >> "%OUTPUT_FILE%"
echo COGNITIVE SERVICE DIAGNOSTICS REPORT >> "%OUTPUT_FILE%"
echo Generated at: %DATE% %TIME% >> "%OUTPUT_FILE%"
echo Namespace: %NAMESPACE% >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"

:: -------------------------------------------------------
:: 1. Pod Status Overview
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 1. POD STATUS OVERVIEW >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl get pods -n %NAMESPACE% -o wide >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 2. Pod Describe
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 2. POD DESCRIBE >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"

echo --- Describe: %POD1% --- >> "%OUTPUT_FILE%"
kubectl describe pod %POD1% -n %NAMESPACE% >> "%OUTPUT_FILE%" 2>&1

echo --- Describe: %POD2% --- >> "%OUTPUT_FILE%"
kubectl describe pod %POD2% -n %NAMESPACE% >> "%OUTPUT_FILE%" 2>&1

echo --- Describe: %POD3% --- >> "%OUTPUT_FILE%"
kubectl describe pod %POD3% -n %NAMESPACE% >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 3. Current Pod Logs
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 3. CURRENT POD LOGS (last 200 lines) >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"

echo --- Current Logs: %POD1% --- >> "%OUTPUT_FILE%"
kubectl logs %POD1% -n %NAMESPACE% --timestamps=true --tail=200 >> "%OUTPUT_FILE%" 2>&1

echo --- Current Logs: %POD2% --- >> "%OUTPUT_FILE%"
kubectl logs %POD2% -n %NAMESPACE% --timestamps=true --tail=200 >> "%OUTPUT_FILE%" 2>&1

echo --- Current Logs: %POD3% --- >> "%OUTPUT_FILE%"
kubectl logs %POD3% -n %NAMESPACE% --timestamps=true --tail=200 >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 4. Previous (Crashed) Pod Logs
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 4. PREVIOUS (CRASHED) POD LOGS >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"

echo --- Previous Logs: %POD1% --- >> "%OUTPUT_FILE%"
kubectl logs %POD1% -n %NAMESPACE% --previous --timestamps=true >> "%OUTPUT_FILE%" 2>&1

echo --- Previous Logs: %POD2% --- >> "%OUTPUT_FILE%"
kubectl logs %POD2% -n %NAMESPACE% --previous --timestamps=true >> "%OUTPUT_FILE%" 2>&1

echo --- Previous Logs: %POD3% --- >> "%OUTPUT_FILE%"
kubectl logs %POD3% -n %NAMESPACE% --previous --timestamps=true >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 5. Pod Resource Metrics
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 5. POD RESOURCE METRICS >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl top pods -n %NAMESPACE% >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 6. Node Resource Metrics
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 6. NODE RESOURCE METRICS >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl top nodes >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 7. Node Describe
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 7. NODE DESCRIBE (Conditions + Allocated Resources) >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"

echo --- Node: %NODE1% --- >> "%OUTPUT_FILE%"
kubectl describe node %NODE1% >> "%OUTPUT_FILE%" 2>&1

echo --- Node: %NODE2% --- >> "%OUTPUT_FILE%"
kubectl describe node %NODE2% >> "%OUTPUT_FILE%" 2>&1

echo --- Node: %NODE3% --- >> "%OUTPUT_FILE%"
kubectl describe node %NODE3% >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 8. Namespace Events
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 8. NAMESPACE EVENTS (sorted by lastTimestamp) >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl get events -n %NAMESPACE% --sort-by=.lastTimestamp >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 9. Deployment Status
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 9. DEPLOYMENT STATUS >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl describe deployment cognitive-service-app -n %NAMESPACE% >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 10. HPA Status
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 10. HPA STATUS >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl get hpa -n %NAMESPACE% >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 11. Upstream Caller Lookup
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 11. UPSTREAM CALLER LOOKUP (10.44.239.98) >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl get pods -n %NAMESPACE% -o wide >> "%OUTPUT_FILE%" 2>&1
kubectl get pods --all-namespaces -o wide >> "%OUTPUT_FILE%" 2>&1

:: -------------------------------------------------------
:: 12. Restart Summary
:: -------------------------------------------------------
echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo >>> 12. RESTART COUNT SUMMARY >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
kubectl get pods -n %NAMESPACE% -o jsonpath="{range .items[*]}{.metadata.name}{'\t'}Restarts: {.status.containerStatuses[0].restartCount}{'\t'}Last State: {.status.containerStatuses[0].lastState.terminated.reason}{'\t'}Exit Code: {.status.containerStatuses[0].lastState.terminated.exitCode}{'\n'}{end}" >> "%OUTPUT_FILE%" 2>&1

echo. >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"
echo COLLECTION COMPLETE >> "%OUTPUT_FILE%"
echo ============================================================ >> "%OUTPUT_FILE%"

echo.
echo ============================================================
echo  DONE! File saved to:
echo  %OUTPUT_FILE%
echo ============================================================
echo.
pause
