import { Response } from "express";
interface ApiSuccess<T> {
    success: true;
    data: T;
}

interface ApiError {
    success: false;
    title: string;
    message: string;
}

export function sendSuccess<T>(
    res: Response,
    data: T,
    statusCode: number = 200
) {
    const response: ApiSuccess<T> = {
        success: true,
        data
    };

    return res.status(statusCode).json(response);
}

export function sendError(
    res: Response,
    title: string,
    message: string,
    statusCode: number
) {
    const response: ApiError = {
        success: false,
        title,
        message
    };

    return res.status(statusCode).json(response);
}