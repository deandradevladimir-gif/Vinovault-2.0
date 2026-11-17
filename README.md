<div align="center">

<img src="frontend/src/assets/logo.png" alt="VinoVault" width="120" />

# VinoVault

**Sistema web de gestión de inventario y ventas para distribuidoras de vinos**

[![Demo](https://img.shields.io/badge/demo-vino--vault2--0.vercel.app-7b1e3a?style=for-the-badge)](https://vino-vault2-0.vercel.app)

![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?logo=typescript&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?logo=react&logoColor=61DAFB)
![Vite](https://img.shields.io/badge/Vite-646CFF?logo=vite&logoColor=white)
![MUI](https://img.shields.io/badge/Material_UI-007FFF?logo=mui&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-339933?logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?logo=express&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3FCF8E?logo=supabase&logoColor=white)
![License](https://img.shields.io/badge/licencia-BSD--3-blue)

</div>

---

## Sobre el proyecto

VinoVault es una aplicación **full-stack** escrita íntegramente en **TypeScript** que centraliza la operación diaria de una distribuidora de vinos: catálogo de productos, stock en varios almacenes, clientes, ventas con emisión de recibos y reportes.

Está pensada para un contexto real de frontera, por lo que **opera en tres monedas (USD, PYG y BRL)** con tasas de cambio obtenidas en tiempo real de una API externa.

## Capturas

![Dashboard con inventario y precios en tres monedas](docs/screenshots/dashboard.webp)

<table>
  <tr>
    <td width="50%"><img src="docs/screenshots/checkout.webp" alt="Carrito y checkout en guaraníes" /><br/><sub><b>Checkout</b>: cliente, almacén de origen, moneda e IVA automático</sub></td>
    <td width="50%"><img src="docs/screenshots/reportes.webp" alt="Reporte de ventas por rango de fechas" /><br/><sub><b>Reportes</b>: resumen y detalle por período, exportable a PDF</sub></td>
  </tr>
  <tr>
    <td width="50%"><img src="docs/screenshots/receipt.webp" alt="Comprobante de venta" /><br/><sub><b>Comprobante</b> imprimible en la moneda de la venta</sub></td>
    <td width="50%"><img src="docs/screenshots/cliente.webp" alt="Perfil de cliente" /><br/><sub><b>Perfil de cliente</b> con historial de compras y gasto total en USD, PYG y BRL</sub></td>
  </tr>
  <tr>
    <td width="50%"><img src="docs/screenshots/historial.webp" alt="Historial de ventas" /><br/><sub><b>Historial</b>: ventas con vendedor, estado y reimpresión de comprobante</sub></td>
    <td width="50%"><img src="docs/screenshots/dashboard-light.webp" alt="Tema claro" /><br/><sub><b>Tema claro</b>, además del oscuro</sub></td>
  </tr>
  <tr>
    <td width="50%"><img src="docs/screenshots/login.webp" alt="Pantalla de inicio de sesión" /><br/><sub><b>Login</b> con autenticación JWT</sub></td>
    <td width="50%" align="center"><img src="docs/screenshots/mobile.webp" alt="Vista móvil" width="200" /><br/><sub><b>Diseño responsive</b></sub></td>
  </tr>
</table>

<sub>Capturas tomadas con datos de ejemplo ficticios.</sub>

## Funcionalidades

| Área | Qué permite |
|---|---|
| **Autenticación y roles** | Login con JWT y contraseñas cifradas con bcrypt. Rol **admin** (gestión de usuarios y alta de cuentas) y rol **vendedor**, con rutas protegidas en frontend y backend. |
| **Productos** | Alta, edición y baja de productos con SKU único, precios de compra y venta, e imágenes almacenadas en **Supabase Storage**. |
| **Inventario multi-almacén** | Stock por producto y almacén, ajustes de entrada/salida e **historial de movimientos** con el usuario responsable. |
| **Ventas** | Carrito, checkout con selección de cliente y moneda, e **impresión de recibos** (adaptada también a móvil). Los importes se guardan siempre en USD y se convierten al mostrarlos, con una única fuente de tasas de cambio. Cada venta descuenta el stock **dentro de una transacción**, de modo que nunca queda a medias. |
| **Clientes** | Gestión de clientes locales y extranjeros (RUC) y perfil con su historial de compras. |
| **Dashboard** | Indicadores de stock y ventas y tasas de cambio del día. |
| **Reportes** | Reportes de ventas y de stock filtrados por rango de fechas, **exportables a PDF**. |
| **Interfaz** | Diseño responsive con Material UI y tema claro/oscuro. |

## Arquitectura

```mermaid
flowchart LR
    U([Usuario]) --> FE

    subgraph Vercel
        FE["Frontend<br/>React + Vite + MUI"]
    end

    FE -- "REST + JWT (Axios)" --> API

    subgraph Backend
        API["API REST<br/>Node.js + Express"]
    end

    API --> DB[(PostgreSQL)]
    API --> ST[["Supabase Storage<br/>imágenes"]]
    API --> FX{{"ExchangeRate-API<br/>USD · PYG · BRL"}}
```

El backend sigue una separación en capas **routes → controllers → services**, con middlewares para autenticación, autorización por rol y subida de archivos.

## Modelo de datos

```mermaid
erDiagram
    USUARIOS ||--o{ VENTAS : registra
    USUARIOS ||--o{ MOVIMIENTOS_STOCK : realiza
    CLIENTES ||--o{ VENTAS : compra
    ALMACENES ||--o{ INVENTARIO : contiene
    ALMACENES ||--o{ MOVIMIENTOS_STOCK : afecta
    ALMACENES ||--o{ VENTAS : origen
    PRODUCTOS ||--o{ INVENTARIO : "stock en"
    PRODUCTOS ||--o{ MOVIMIENTOS_STOCK : referencia
    PRODUCTOS ||--o{ VENTA_ITEMS : "se vende en"
    VENTAS ||--|{ VENTA_ITEMS : compone

    USUARIOS {
        int id PK
        string email UK
        string contrasena_hash
        string nombre_completo
        string rol
        bool activo
    }
    CLIENTES {
        int id PK
        string nombre
        string ruc
        string telefono
        string email
        bool es_extranjero
    }
    PRODUCTOS {
        int id PK
        string sku UK
        string nombre
        decimal precio_compra
        decimal precio_venta
        string imagen_url
    }
    ALMACENES {
        int id PK
        string nombre
        string ubicacion
    }
    INVENTARIO {
        int producto_id PK, FK
        int almacen_id PK, FK
        int cantidad
    }
    MOVIMIENTOS_STOCK {
        int id PK
        int producto_id FK
        int almacen_id FK
        int usuario_id FK
        string tipo_movimiento
        int cantidad
    }
    VENTAS {
        int id PK
        int cliente_id FK
        int usuario_id FK
        int almacen_id FK
        string moneda
        decimal subtotal
        decimal impuesto
        decimal total
        string estado
    }
    VENTA_ITEMS {
        int id PK
        int venta_id FK
        int producto_id FK
        int cantidad
        decimal precio_unitario
    }
```

El script completo de creación está en [`backend/database/schema.sql`](backend/database/schema.sql).

## Stack técnico

**Frontend:** React 18 · TypeScript · Vite · Material UI · React Router · Context API (auth, carrito, tema) · Axios · jsPDF + html2canvas · react-to-print

**Backend:** Node.js · Express 5 · TypeScript · PostgreSQL (`pg`) · JWT · bcryptjs · Multer · Supabase Storage · ExchangeRate-API

**Despliegue:** frontend en Vercel

## Ejecución local

**Requisitos:** Node.js 18+, PostgreSQL y un proyecto de Supabase con un bucket de Storage para las imágenes.

```bash
git clone https://github.com/deandradevladimir-gif/Vinovault-2.0.git
cd Vinovault-2.0
```

**1. Base de datos**

```bash
createdb vinovault
psql -d vinovault -f backend/database/schema.sql
```

**2. Backend:** crea `backend/.env`:

```env
PORT=5001
DATABASE_URL=postgresql://usuario:contraseña@localhost:5432/vinovault
JWT_SECRET=una_clave_larga_y_aleatoria
EXCHANGE_RATE_API_KEY=tu_api_key        # https://www.exchangerate-api.com
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=tu_anon_key
```

```bash
cd backend
npm install
npm run dev        # http://localhost:5001  ·  comprobación: /api/health
```

**3. Frontend:** crea `frontend/.env`:

```env
VITE_API_URL=http://localhost:5001/api
VITE_API_BASE_URL=http://localhost:5001
```

```bash
cd frontend
npm install
npm run dev        # http://localhost:5173
```

## Estructura del proyecto

```
Vinovault-2.0/
├── backend/
│   ├── database/
│   │   └── schema.sql       # Esquema de PostgreSQL
│   └── src/
│       ├── config/          # Cliente de Supabase
│       ├── routes/          # Definición de endpoints
│       ├── controllers/     # Manejo de peticiones y respuestas
│       ├── services/        # Lógica de negocio y acceso a datos
│       ├── middleware/      # JWT, roles y subida de imágenes
│       └── index.ts         # Servidor Express
└── frontend/
    └── src/
        ├── pages/           # Dashboard, Historial, Reportes, Clientes, Usuarios...
        ├── components/      # Modales, tarjetas de producto, layout, rutas protegidas
        ├── context/         # AuthContext, CartContext, ThemeContext
        ├── hooks/           # Impresión de recibos
        ├── theme/           # Tema de Material UI
        └── utils/           # Formato de moneda e imágenes
```

## API

| Recurso | Endpoints principales |
|---|---|
| `/api/auth` | `POST /login` · `POST /register` *(admin)* |
| `/api/productos` | CRUD · `PUT/DELETE /:id/imagen` |
| `/api/inventario` | `POST /movimiento` · `GET /historial` |
| `/api/ventas` | `POST /` · `GET /historial` |
| `/api/clientes` | CRUD · `GET /:id/detalles` |
| `/api/almacenes` | `GET /` |
| `/api/users` | Gestión de usuarios *(admin)* |
| `/api/dashboard` | `GET /stats` · `GET /exchange-rates` |
| `/api/reportes` | `GET /ventas` · `GET /stock` |
| `/api/health` | Estado del servidor y de la conexión a la base de datos |

Todos los endpoints, salvo `login` y `health`, requieren el header `Authorization: Bearer <token>`.

## Autor

**Vladimir De Andrade** · [GitHub](https://github.com/deandradevladimir-gif)

## Licencia

Distribuido bajo la licencia BSD 3-Clause. Ver [`LICENSE`](LICENSE).
