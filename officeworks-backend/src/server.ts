import express from "express";
import axios from "axios";
import { fetchCategories } from "./services/fakeStoreApi";
import { sendEnquiryEmail } from "./services/emailService";
import { searchProducts } from "./services/fakeStoreApi";
import { fetchProductsByCategory } from "./services/fakeStoreApi";
import { fetchProducts } from "./services/fakeStoreApi";
import { fetchProductById } from "./services/fakeStoreApi";
import { Product } from "./models/product";
import { sendSuccess, sendError } from "./utils/apiResponse";
const app = express();


app.use(express.json());

app.use((req, res, next) => {
    console.log(`[${req.method}] ${req.url}`);
    next();
});


app.post("/api/enquiries", async (req, res) => {
    const { productId, name, email, phone, message } = req.body;

    // Validate required fields
    if (
        !productId ||
        !name?.trim() ||
        !email?.trim() ||
        !phone?.trim() ||
        !message?.trim()
    ) {
        return sendError(
            res,
            "Invalid Request",
            "All fields are required.",
            400
        );
    }

    // Validate product ID
    const parsedProductId = Number(productId);

    if (
        !Number.isInteger(parsedProductId) ||
        parsedProductId <= 0
    ) {
        return sendError(
            res,
            "Invalid Product ID",
            "Please provide a valid product ID.",
            400
        );
    }

    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailRegex.test(email.trim())) {
        return sendError(
            res,
            "Invalid Email",
            "Please provide a valid email address.",
            400
        );
    }

    // Fetch product details
    let product;

    try {
        product = await fetchProductById(parsedProductId);
    } catch (error) {
        console.error("Failed to fetch enquiry product:", error);

        if (axios.isAxiosError(error) && error.response?.status === 404) {
            return sendError(
                res,
                "Product Not Found",
                "The requested product could not be found.",
                404
            );
        }

        return sendError(
            res,
            "Service Unavailable",
            "Unable to process the enquiry at the moment.",
            502
        );
    }

    // Prepare enquiry email
    try {
        await sendEnquiryEmail({
            productId: product.id,
            productName: product.title,
            customerName: name.trim(),
            customerEmail: email.trim(),
            customerPhone: phone.trim(),
            message: message.trim()
        });

        return sendSuccess(
            res,
            { message: "Enquiry submitted successfully." },
            201
        );

    } catch (error) {
        console.error("Failed to send enquiry email:", error);

        return sendError(
            res,
            "Email Service Unavailable",
            "Unable to submit your enquiry right now. Please try again later.",
            503
        );
    }
});


app.get("/health", (req, res) => {
    return sendSuccess(res, {
        status: "OK",
        message: "Backend is running"
    });
});

app.get("/api/products", async (req, res) => {
    try {
        const externalProducts = await fetchProducts();

        const products: Product[] = externalProducts.map(product => ({
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            image: product.image,
            rating: product.rating.rate,
            reviews: product.rating.count,
        }));

        return sendSuccess(res, products);

    } catch (error) {
        console.error("Failed to fetch products:", error);

        return sendError(
            res,
            "Service Unavailable",
            "Product service is temporarily unavailable.",
            502
        );
    }
});

app.get("/api/products/search", async (req, res) => {
    try {
        const searchTerm = String(req.query.search || "").trim();

        if (!searchTerm) {
            return sendError(
                res,
                "Invalid Search",
                "Please enter a product name to search.",
                400
            );
        }

        const products = await searchProducts(searchTerm);

        const formattedProducts: Product[] = products.map(product => ({
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            image: product.image,
            rating: product.rating.rate,
            reviews: product.rating.count
        }));

        return sendSuccess(res, formattedProducts);

    } catch (error) {
        console.error("Product search failed:", error);

        return sendError(
            res,
            "Service Unavailable",
            "Unable to search products at the moment.",
            502
        );
    }
});


app.get("/api/products/categories", async (req, res) => {
    try {
        const categories = await fetchCategories();

        return sendSuccess(res, categories);

    } catch (error) {
        console.error("Failed to fetch categories:", error);

        return sendError(
            res,
            "Service Unavailable",
            "Unable to load product categories at the moment.",
            502
        );
    }
});

app.get("/api/products/top-rated", async (req, res) => {
    try {
        const products = await fetchProducts();

        const topRatedProducts = [...products]
            .sort((a, b) => b.rating.rate - a.rating.rate)
            .slice(0, 5);

        const formattedProducts: Product[] = topRatedProducts.map(product => ({
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            image: product.image,
            rating: product.rating.rate,
            reviews: product.rating.count
        }));

        return sendSuccess(res, formattedProducts);

    } catch (error) {
        console.error("Error fetching top-rated products:", error);

        return sendError(
            res,
            "Service Unavailable",
            "Product service is temporarily unavailable.",
            502
        );
    }
});

app.get("/api/products/category/:category", async (req, res) => {
    try {
        const category = req.params.category;

        const externalProducts = await fetchProductsByCategory(category);

        const sortedProducts = [...externalProducts].sort(
            (a, b) => b.rating.rate - a.rating.rate
        );

        const products: Product[] = sortedProducts.map(product => ({
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            image: product.image,
            rating: product.rating.rate,
            reviews: product.rating.count
        }));

        return sendSuccess(res, products);

    } catch (error) {
        console.error("Failed to fetch category products:", error);

        return sendError(
            res,
            "Service Unavailable",
            "Unable to load products for this category.",
            502
        );
    }
});

app.get("/api/products/:id", async (req, res) => {
    try {
        const productId = Number(req.params.id);

        if (!Number.isInteger(productId) || productId <= 0) {
            return sendError(
                res,
                "Invalid Product ID",
                "Please provide a valid product ID.",
                400
            );
        }

        const product = await fetchProductById(productId);

        const formattedProduct: Product = {
            id: product.id,
            title: product.title,
            price: product.price,
            description: product.description,
            category: product.category,
            image: product.image,
            rating: product.rating.rate,
            reviews: product.rating.count
        };

        return sendSuccess(res, formattedProduct);

    } catch (error) {
        console.error("Failed to fetch product:", error);

        if (axios.isAxiosError(error) && error.response?.status === 404) {
            return sendError(
                res,
                "Product Not Found",
                "The requested product could not be found.",
                404
            );
        }

        return sendError(
            res,
            "Service Unavailable",
            "Product service is temporarily unavailable.",
            502
        );
    }
});


app.listen(3000, () => {
    console.log("Server running on port 3000");
});