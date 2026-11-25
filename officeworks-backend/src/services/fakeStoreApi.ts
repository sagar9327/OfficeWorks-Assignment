import axios from "axios";
import type { FakeStoreProduct } from "../models/fakeStoreProduct";
const BASE_URL = "https://fakestoreapi.com";

export async function fetchProducts(): Promise<FakeStoreProduct[]> {
    const response = await axios.get<FakeStoreProduct[]>(
        `${BASE_URL}/products`
    );
    return response.data;
}

export async function fetchProductById(
    id: number
): Promise<FakeStoreProduct> {

    const response = await axios.get<FakeStoreProduct>(
        `${BASE_URL}/products/${id}`
    );

    return response.data;
}

export async function fetchCategories(): Promise<string[]> {
    const response = await axios.get<string[]>(
        `${BASE_URL}/products/categories`
    );

    return response.data;
}

export async function fetchProductsByCategory(
    category: string
): Promise<FakeStoreProduct[]> {

    const response = await axios.get<FakeStoreProduct[]>(
        `${BASE_URL}/products/category/${encodeURIComponent(category)}`
    );

    return response.data;
}

export async function searchProducts(
    searchTerm: string
): Promise<FakeStoreProduct[]> {

    const products = await fetchProducts();

    return products.filter(product =>
        product.title.toLowerCase().includes(searchTerm.toLowerCase())
    );
}
