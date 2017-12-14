import * as mongoose from "mongoose"
import { IUser } from "./index";

var schema = new mongoose.Schema({
    user: {type: mongoose.Schema.Types.ObjectId, required: true, ref: "users"},
    question: {type: String, required: true},
    answer: String,
    answeredAt: Date,
    isDeleted: {type: Boolean, default: false},
    likesCount: {type: Number, default: 0},
}, {
    timestamps: true
})

export interface IQuestion extends mongoose.Document {
    user: IUser | mongoose.Types.ObjectId
    question: string
    answer: string | null
    answeredAt: Date | null
    isDeleted: Boolean
    likesCount: Number
}

export default mongoose.model("questions", schema) as mongoose.Model<IQuestion>