# 🚚 End-to-End Transportation & Logistics Tracking Intelligence System

## 📋 Project Overview
A production-grade, dual-system logistics analytics platform designed to transform reactive supply chain operations into predictive, intelligence-led workflows. The architecture integrates a governed SQL Server relational database for inbound/outbound tracking, Power BI for executive warehouse intelligence, and a Python-based machine learning pipeline that scores shipment delay risk at the moment of booking. The system targets SLA breach reduction, ETA recalibration, vendor accountability, and multi-million dollar revenue preservation.

## 🛠️ Tech Stack
- **Data Engineering & Storage:** Microsoft SQL Server (3NF Schema, 10 BI Views), CSV/Excel ETL
- **Analytical Python Stack:** `pandas`, `numpy`, `scikit-learn`, `mlxtend`, `XGBoost`, `joblib`, `matplotlib`, `seaborn`
- **BI & Visualization:** Power BI (Inbound KPI Dashboards), Orange Data Mining (Visual Pattern Discovery)
- **Deployment & Ops:** FastAPI/Flask (REST API Wrapper), Git/GitHub, Virtual Environments

## 🔄 Data Pipeline & Life-cycle
1. **Ingestion & Validation:** Raw telemetry, booking, and financial records loaded into staging. Timeline validation enforces `actual_eta >= booking_date`.
2. **Cleaning & Imputation:** String normalization (Title Case/strip), PII removal, duplicate BookingID resolution, Haversine-based distance imputation for missing GPS coordinates.
3. **Feature Engineering:** Extraction of temporal (`pickup_hour`, `booking_month`, `is_weekend`), geospatial (`log_distance`), and categorical encodings. `ColumnTransformer` applies median imputation + `StandardScaler` to numerical tracks and `OneHotEncoder` to categorical tracks.
4. **Pattern Discovery:** K-Means clustering (K=4), Apriori association rules (min_support=0.01, min_confidence=0.3), Isolation Forest anomaly detection.
5. **Predictive Modeling:** Stratified 80/20 train-test split. Pipeline training with cross-validation. Hyperparameter tuning and model serialization.

## ⚙️ Code Logic & Models
- **Preprocessing Pipeline:** `scikit-learn` `Pipeline` + `ColumnTransformer` ensures leak-free transformations. Categorical: `strategy='constant', fill_value='missing'` → `OneHotEncoder`. Numerical: `strategy='median'` → `StandardScaler`.
- **Delay Classification (Primary):** 
  - `RandomForestClassifier`: `n_estimators=100`, `class_weight='balanced'`, `oob_score=True`
  - `GradientBoostingClassifier`: `n_estimators=100`, `learning_rate=0.1`, `max_depth=3`
- **Trip Duration Regression:** 
  - `XGBRegressor`: Optimized for continuous duration forecasting with L2 regularization.
- **Unsupervised Learning:** 
  - `KMeans`: Silhouette-optimized `K=4` for shipment/hub segmentation.
  - `mlxtend.frequent_patterns.apriori`: Discovers delay-causing attribute combinations (e.g., `DIST:Short`, `GPS:Consent`, `TIME:Evening`).

## 📊 Evaluation Metrics
| Model/Task | Primary Metric | Result |
|------------|----------------|--------|
| Delay Classification (GB) | Precision-Recall AUC | **0.9554** |
| Delay Classification (RF) | Cross-validated PR-AUC | 0.9421 |
| Trip Duration Regression | MAE | **31.70 hours** |
| Trip Duration Regression | RMSE | 44.74 hours |
| Trip Duration Regression | R² | 0.4686 |
| Clustering (Shipment) | Silhouette Score (K=4) | 0.365 |
| Association Rules | Max Lift | 4.5846 |

## 🔍 Key Findings
- **Fulfillment Gap:** Current Order Fulfillment Rate stands at **84.97%**, a **10.03 pp deficit** against the 95% industry benchmark, exposing **~$38.67M/month** in recoverable revenue.
- **Inventory Risk:** **237 critical SKUs (7.4%)** operate below reorder thresholds, with Automotive and Pharma categories showing highest stockout frequencies.
- **Delay Predictors:** Historical delay rate is **58.3%**. Delay probability scales proportionally with route distance (>1,000 km). Association rules identify evening bookings + short routes + specific GPS providers as high-lift delay combinations.
- **Vendor Accountability:** Specific vendors (e.g., Otis Elevator, Wipro) exhibit systemic SLA failures (98–100% delay rates), requiring targeted Performance Improvement Plans.

