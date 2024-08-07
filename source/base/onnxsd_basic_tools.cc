﻿/*
 * BasicTools
 * Definition: put simple tools we used in here
 * Created by Arikan.Li on 2022/03/11.
 */
#ifndef ONNX_SD_CORE_TOOLS_ONCE
#define ONNX_SD_CORE_TOOLS_ONCE

#include "onnxsd_basic_refs.h"

namespace onnx {
namespace sd {
namespace base {
using namespace amon;

class RandomGenerator {
protected:
    std::default_random_engine random_generator;
//    std::normal_distribution<float> random_style;
    std::uniform_real_distribution<float> random_style;

public:
    explicit RandomGenerator(float mean_ = 0.0f, float stddev_ = 1.0f) {
        random_style = std::uniform_real_distribution<float>();
//        random_style = std::normal_distribution<float>(mean_, stddev_);
    }

    ~RandomGenerator() {
        random_style.reset();
    }

    void seed(int64_t seed_) {
        if (seed_ == 0) return;
        if (seed_ == -1) {
            std::random_device rd;
            std::mt19937 gen(rd());
            std::uniform_int_distribution<> dis(0, (std::numeric_limits<int>::max)());
            seed_ = dis(gen);
        }
        this->random_generator.seed(int(seed_));
    }

    float next() {
        float u1 = random_style(random_generator);
        float u2 = random_style(random_generator);
        float radius = std::sqrt(-2.0f * std::log(u1));
        float theta = float(2.0f * M_PI) * u2;
        float standard = radius * std::cos(theta);
        return standard;
//        return random_style(random_generator);
    }
};

class IntegralHelper {
public:
    template<class T>
    static T simpson_integral(std::function<T(T)> f, T a, T b, int n = 1000) {
        T h = (b - a) / n;
        T sum = f(a) + f(b);
        for (int i = 1; i < n; i += 2) {
            sum += 4 * f(a + i * h);
        }
        for (int i = 2; i < n - 1; i += 2) {
            sum += 2 * f(a + i * h);
        }
        return sum * h / 3.0;
    }

    template<class T>
    static T trapezoidal_integral(std::function<T(T)> f, T a, T b, int n = 1000) {
        T h = (b - a) / n;
        T sum = T(0.5 * (f(a) + f(b)));
        for (int i = 1; i < n; ++i) {
            sum += f(a + i * h);
        }
        return sum * h;
    }
};

class TensorHelper {

#define GET_TENSOR_DATA_SIZE(tensor_shape_, shape_size_) \
    [&]()->long{                                         \
        int64_t data_size_ = 1;                          \
        for (long long i: tensor_shape_) {               \
            data_size_ = data_size_ * i;                 \
        }                                                \
        return (long)(data_size_ * shape_size_);         \
    }()

#define GET_TENSOR_DATA_INFO(tensor_, tensor_data_, tensor_shape_, shape_size_, type_)  \
    auto *tensor_data_ = tensor_.GetTensorData<type_>();                                \
    TensorShape tensor_shape_ = tensor_.GetTensorTypeAndShapeInfo().GetShape();         \
    size_t shape_size_ = tensor_.GetTensorTypeAndShapeInfo().GetElementCount()

public:
    template<class T>
    static void print_tensor_data(const Tensor &tensor_, const std::string &mark_) {
        auto tensor_info = tensor_.GetTensorTypeAndShapeInfo();
        auto shape = tensor_info.GetShape();
        size_t total_elements = tensor_info.GetElementCount();
        auto data = tensor_.GetTensorData<T>();

        std::cout << mark_;

        std::vector<size_t> indices(shape.size(), 0);
        size_t depth = 0;
        size_t index = 0;

        auto print_indent = [](size_t depth) {
            for (size_t i = 0; i < depth; ++i) {
                std::cout << "    ";
            }
        };

        while (true) {
            if (depth == shape.size() - 1) {
                print_indent(depth);
                std::cout << "[" << std::endl;;
                print_indent(depth + 1);
                for (indices[depth] = 0; indices[depth] < shape[depth]; ++indices[depth]) {
                    std::cout << data[index++];
                    if (indices[depth] < shape[depth] - 1) {
                        std::cout << ", ";
                        if (indices[depth] % 3 == 2) {
                            std::cout << std::endl;
                            print_indent(depth + 1);
                        }
                    }
                }
                std::cout << std::endl;
                print_indent(depth);
                std::cout << "]";
                if (depth == 0) break;
                --depth;
                ++indices[depth];
                std::cout << std::endl;
            } else {
                if (indices[depth] == 0) {
                    print_indent(depth);
                    std::cout << "[" << std::endl;
                }
                if (indices[depth] < shape[depth]) {
                    ++depth;
                    indices[depth] = 0;
                } else {
                    print_indent(depth);
                    std::cout << "]";
                    std::cout << std::endl;
                    if (depth == 0) break;
                    --depth;
                    ++indices[depth];
                    if (indices[depth] < shape[depth]) {
                        print_indent(depth);
                        std::cout << "," << std::endl;
                    }
                }
            }
        }

        std::cout << mark_ << " Shape: [";
        for (size_t i = 0; i < shape.size(); ++i) {
            std::cout << shape[i];
            if (i < shape.size() - 1) {
                std::cout << ", ";
            }
        }
        std::cout << "]" << std::endl;
    }

    static long get_data_size(const Tensor &input_) {
        long input_size_ = (long) input_.GetTensorTypeAndShapeInfo().GetElementCount();
        return input_size_;
    }

    static TensorShape get_shape(const Tensor &input_) {
        TensorShape shape_ = input_.GetTensorTypeAndShapeInfo().GetShape();
        return shape_;
    }

    static std::string get_tensor_type(ONNXTensorElementDataType type) {
        switch (type) {
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_UNDEFINED:
                return "undefined";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT:
                return "float32";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT8:
                return "uint8";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_INT8:
                return "int8";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT16:
                return "uint16";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_INT16:
                return "int16";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_INT32:
                return "int32";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_INT64:
                return "int64";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_STRING:
                return "string";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_BOOL:
                return "bool";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_FLOAT16:
                return "float16";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_DOUBLE:
                return "float64";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT32:
                return "uint32";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_UINT64:
                return "uint64";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX64:
                return "complex64";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_COMPLEX128:
                return "complex128";
            case ONNX_TENSOR_ELEMENT_DATA_TYPE_BFLOAT16:
                return "bfloat16";
            default:
                throw logic_error("Unsupported tensor type.");
        }
    }

    template<class T>
    static Tensor empty() {
        return TensorHelper::create<T>(TensorShape{0}, std::vector<T>{});
    }

    static bool have_data(const Tensor &input_) {
        return bool(input_.GetTensorTypeAndShapeInfo().GetElementCount() != 0);
    }

    template<class T>
    static Tensor create(TensorShape shape_, vector<T> value_) {
        long input_size_ = GET_TENSOR_DATA_SIZE(shape_, 1);
        auto result_data_ = new T[input_size_];

        for (int i = 0; i < input_size_; i++) {
            result_data_[i] = value_[i];
        }

        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            Ort::MemoryInfo::CreateCpu(
                OrtAllocatorType::OrtArenaAllocator, OrtMemType::OrtMemTypeDefault
            ), result_data_, input_size_,
            shape_.data(), shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor random(TensorShape shape_, RandomGenerator random_, float factor_ = 1.0f) {
        long input_size_ = GET_TENSOR_DATA_SIZE(shape_, 1);
        auto result_data_ = new T[input_size_];

        for (int i = 0; i < input_size_; i++) {
            result_data_[i] = random_.next() * factor_;
        }

        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            Ort::MemoryInfo::CreateCpu(
                OrtAllocatorType::OrtArenaAllocator, OrtMemType::OrtMemTypeDefault
            ), result_data_, input_size_,
            shape_.data(), shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor blur(const Tensor &input_, RandomGenerator random_, float factor_ = 1.0f) {
        GET_TENSOR_DATA_INFO(input_, input_data_, input_shape_, input_size_, T);
        auto result_data_ = new T[input_size_];

        int64_t max_w_ = input_shape_[3];
        int64_t max_h_ = input_shape_[2];
        int64_t max_c_ = input_shape_[1];
        int64_t max_s_ = input_shape_[0];
        int64_t out_c_ = max_c_ / 2;

        for (int i = 0; i < max_s_; i++) {
            for (int c = 0; c < out_c_; c++) {
                for (int h = 0; h < max_h_; h++) {
                    for (int w = 0; w < max_w_; w++) {
                        int64_t cur_at_ = (((i * max_c_ + c) * max_h_ + h) * max_w_ + w) ;
                        int64_t var_at_ = (((i * max_c_ + (c + out_c_)) * max_h_ + h) * max_w_ + w) ;
                        float mean_ = input_data_[cur_at_];
                        float logvar_ = input_data_[var_at_];
                        logvar_ = max(-30.0f, min(logvar_, 20.0f));
                        result_data_[i] = mean_ + std::exp(0.5f * logvar_) * random_.next();
                        result_data_[i] *= factor_;
                    }
                }
            }
        }

        TensorShape result_shape_{max_s_, out_c_, max_h_, max_w_};
        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_.GetTensorMemoryInfo(), result_data_, input_size_,
            result_shape_.data(), result_shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor divide(const Tensor &input_, float denominator_, float offset_ = 0.0f, bool normalize_ = false) {
        GET_TENSOR_DATA_INFO(input_, input_data_, input_shape_, input_size_, T);
        auto result_data_ = new T[input_size_];

        for (int i = 0; i < input_size_; i++) {
            result_data_[i] = (
                normalize_ ?
                min(max((input_data_[i] / denominator_ + offset_), 0.0f), 1.0f) :
                (input_data_[i] / denominator_ + offset_)
            );
        }

        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_.GetTensorMemoryInfo(), result_data_, input_size_,
            input_shape_.data(), input_shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor multiple(const Tensor &input_, float multiplier_, float offset_ = 0.0f) {
        GET_TENSOR_DATA_INFO(input_, input_data_, input_shape_, input_size_, T);
        auto result_data_ = new T[input_size_];

        for (int i = 0; i < input_size_; i++) {
            result_data_[i] = input_data_[i] * multiplier_ + offset_;
        }

        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_.GetTensorMemoryInfo(), result_data_, input_size_,
            input_shape_.data(), input_shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor duplicate(const Tensor &input_) {
        GET_TENSOR_DATA_INFO(input_, input_data_, input_shape_, input_size_, T);
        T* result_data_ = new T[input_size_ * 2];

        for (int i = 0; i < input_size_; i++) {
            result_data_[i] = input_data_[i];
            result_data_[input_size_ + i] = input_data_[i];
        }

        TensorShape result_shape_ = input_shape_;
        result_shape_[0] *= 2;
        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_.GetTensorMemoryInfo(), result_data_, input_size_ * 2,
            result_shape_.data(), result_shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor clone(const Tensor &input_, const TensorShape &shape_ = {}) {
        GET_TENSOR_DATA_INFO(input_, input_data_, input_shape_, input_size_, T);
        T* result_data_ = new T[input_size_];

        for (int i = 0; i < input_size_; i++) {
            result_data_[i] = input_data_[i];
        }

        TensorShape result_shape_ = shape_.empty() ? input_shape_ : shape_;
        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_.GetTensorMemoryInfo(), result_data_, input_size_,
            result_shape_.data(), result_shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static std::vector<Tensor> split(const Tensor &input_, const TensorShape &shape_ = {}) {
        GET_TENSOR_DATA_INFO(input_, input_data_, input_shape_, input_size_, T);
        long split_size_ = GET_TENSOR_DATA_SIZE(shape_, 1);
        auto split_data_l_ = new T[split_size_];
        auto split_data_r_ = new T[split_size_];
        bool enough_data_ = (long(input_size_) == long(split_size_ * 2));

        int64_t max_w_ = input_shape_[3];
        int64_t max_h_ = input_shape_[2];
        int64_t max_c_ = input_shape_[1];
        int64_t max_s_ = input_shape_[0];
        int64_t out_s_ = max_s_ / 2;

        for (int i = 0; i < out_s_; i++) {
            for (int c = 0; c < max_c_; c++) {
                for (int h = 0; h < max_h_; h++) {
                    for (int w = 0; w < max_w_; w++) {
                        int64_t data_at_ = (((i * max_c_ + c) * max_h_ + h) * max_w_ + w) ;
                        split_data_l_[data_at_] = input_data_[data_at_];
                        split_data_r_[data_at_] = input_data_[data_at_ + split_size_];
                    }
                }
            }
        }

        std::vector<Tensor> result_;
        result_.push_back(Tensor::CreateTensor<T>(
            input_.GetTensorMemoryInfo(), split_data_l_, split_size_,
            shape_.data(), shape_.size()
        ));
        result_.push_back(Tensor::CreateTensor<T>(
            input_.GetTensorMemoryInfo(), split_data_r_, split_size_,
            shape_.data(), shape_.size()
        ));

        return result_;
    }

    template<class T>
    static Tensor merge(const std::vector<Tensor> &input_tensors_, int offset_) {
        TensorShape input_shape_ = input_tensors_[0].GetTensorTypeAndShapeInfo().GetShape();
        size_t input_size_ = input_tensors_[0].GetTensorTypeAndShapeInfo().GetElementCount();
        long tensor_num_ = long(input_tensors_.size());   // [1, 77, 768]

        long result_size_ = long(input_size_ * tensor_num_);
        auto result_data_ = new T[result_size_];

        long inner_dim = long(std::accumulate(
            input_shape_.begin() + offset_ + 1, input_shape_.end(), 1LL, std::multiplies<>()
        ));  // 768
        long outer_dim = long(std::accumulate(
            input_shape_.begin(), input_shape_.end() - offset_ - 1, 1LL, std::multiplies<>()
        )); // 1
        long concat_dim = long(input_shape_[offset_]);    //  77
        long newest_dim = concat_dim * tensor_num_; // 154

        for (int l = 0; l < outer_dim; ++l) {           // 1
            for (int m = 0; m < concat_dim; ++m) {      // 77
                for (int i = 0; i < inner_dim; ++i) {   // 768
                    for (long index_ = 0; index_ < tensor_num_; ++index_) {  // 2
                        auto *input_data_ = input_tensors_[index_].GetTensorData<T>();
                        long n = m + index_ * concat_dim;
                        long old_index = l * concat_dim * inner_dim + m * inner_dim + i;
                        long new_index = l * newest_dim * inner_dim + n * inner_dim + i;
                        //  C6386: make sure in range
                        if (new_index >= result_size_ || old_index >= input_size_) {
                            delete[] result_data_;
                            throw std::out_of_range("Index out of range");
                        }
                        result_data_[new_index] = input_data_[old_index];
                    }
                }
            }
        }

        TensorShape shape_ = input_shape_;
        shape_[offset_] *= tensor_num_;

        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_tensors_[0].GetTensorMemoryInfo(), result_data_, result_size_,
            shape_.data(), shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor guide(const Tensor &input_l_, const Tensor &input_r_, float guidance_scale_) {
        GET_TENSOR_DATA_INFO(input_l_, input_data_l_, input_shape_l_, input_size_l_, T);
        GET_TENSOR_DATA_INFO(input_r_, input_data_r_, input_shape_r_, input_size_r_, T);

        if (input_size_l_ != input_size_r_){
            amon_exception(basic_exception(EXC_LOG_ERR, "ERROR:: 2 Tensors guidance without match"));
        }

        long result_size_ = long(input_size_l_);
        auto result_data_ = new T[result_size_];

        for (int i = 0; i < result_size_; i++) {
            result_data_[i] = input_data_l_[i] + guidance_scale_ * (input_data_r_[i] - input_data_l_[i]);
        }

        TensorShape result_shape_ = input_shape_l_;
        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_l_.GetTensorMemoryInfo(), result_data_, result_size_,
            result_shape_.data(), result_shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor weight(const Tensor &input_l_, const Tensor &input_r_, int offset_, bool re_normalize_ = false) {
        GET_TENSOR_DATA_INFO(input_l_, input_data_l_, input_shape_l_, input_size_l_, T);
        GET_TENSOR_DATA_INFO(input_r_, input_data_r_, input_shape_r_, input_size_r_, T);

        long result_size_ = long(input_size_l_);
        auto result_data_ = new T[result_size_];

        float original_mean_ = 0.0f;
        float weighted_mean_ = 0.0f;
        size_t elements_per_r = std::accumulate(
            input_shape_l_.begin() + offset_ + 1, input_shape_l_.end(), 1LL, std::multiplies<>()
        );
        for (size_t i = 0; i < size_t(input_shape_r_[offset_]); ++i) {
            for (size_t j = 0; j < elements_per_r; ++j) {
                result_data_[i * elements_per_r + j] = input_data_l_[i * elements_per_r + j] * input_data_r_[i];
                original_mean_ += input_data_l_[i * elements_per_r + j] / float(input_size_l_) ;
                weighted_mean_ += result_data_[i * elements_per_r + j] / float(input_size_l_) ;
            }
        }

        TensorShape shape_ = input_shape_l_;
        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_l_.GetTensorMemoryInfo(), result_data_, result_size_,
            shape_.data(), shape_.size()
        );

        if (re_normalize_){
            float normalize_factor_ = original_mean_ / weighted_mean_;
            result_tensor_ = multiple<T>(result_tensor_, normalize_factor_);
        }

        return result_tensor_;
    }

    template<class T>
    static Tensor add(const Tensor &input_l_, const Tensor &input_r_, const TensorShape& shape_) {
        GET_TENSOR_DATA_INFO(input_l_, input_data_l_, input_shape_l_, input_size_l_, T);
        GET_TENSOR_DATA_INFO(input_r_, input_data_r_, input_shape_r_, input_size_r_, T);

        if (input_size_l_ != input_size_r_){
            amon_exception(basic_exception(EXC_LOG_ERR, "ERROR:: 2 Tensors adding with data not match"));
        }

        long result_size_ = long(input_size_l_);
        auto result_data_ = new T[result_size_];

        for (int i = 0; i < result_size_; i++) {
            result_data_[i] = input_data_l_[i] + input_data_r_[i];
        }

        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_l_.GetTensorMemoryInfo(), result_data_, result_size_,
            shape_.data(), shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor sub(const Tensor &input_l_, const Tensor &input_r_, const TensorShape& shape_) {
        GET_TENSOR_DATA_INFO(input_l_, input_data_l_, input_shape_l_, input_size_l_, T);
        GET_TENSOR_DATA_INFO(input_r_, input_data_r_, input_shape_r_, input_size_r_, T);

        if (input_size_l_ != input_size_r_){
            amon_exception(basic_exception(EXC_LOG_ERR, "ERROR:: 2 Tensors subtract with data not match"));
        }

        long result_size_ = long(input_size_l_);
        auto result_data_ = new T[result_size_];

        for (int i = 0; i < result_size_; i++) {
            result_data_[i] = input_data_l_[i] - input_data_r_[i];
        }

        Tensor result_tensor_ = Tensor::CreateTensor<T>(
            input_l_.GetTensorMemoryInfo(), result_data_, result_size_,
            shape_.data(), shape_.size()
        );

        return result_tensor_;
    }

    template<class T>
    static Tensor sum(const Tensor* input_tensors_, const long input_size_, const TensorShape& shape_) {
        Tensor result_ = clone<T>(input_tensors_[0], shape_);
        for (int i = 1; i < input_size_; ++i) {
            result_ = add<T>(result_, input_tensors_[i], shape_);
        }
        return result_;
    }

#undef GET_TENSOR_DATA_INFO
#undef GET_TENSOR_DATA_SIZE
};

class PromptsHelper {
public:
    static std::string whitespace(std::string &text) {
        return std::regex_replace(text, std::regex("\\s+"), " ");
    }

    static std::vector<std::string> split(const std::string &str, const std::regex &regex, bool match_break = true){
        if (match_break) {
            std::sregex_token_iterator first(str.begin(), str.end(), regex, -1);
            std::sregex_token_iterator last;
            return {first, last};
        } else {
            std::vector<std::string> result;
            auto words_begin = std::sregex_iterator(str.begin(), str.end(), regex);
            auto words_end = std::sregex_iterator();

            for (std::sregex_iterator i = words_begin; i != words_end; ++i) {
                std::smatch match = *i;
                result.push_back(match.str());
            }

            return result;
        }
    }

    static std::string replace(const std::string & s, const std::string & from, const std::string & to) {
        std::string result = s;
        size_t pos = 0;
        while ((pos = result.find(from, pos)) != std::string::npos) {
            result.replace(pos, from.length(), to);
            pos += to.length();
        }
        return result;
    }

    static bool has_extension(const std::string& filename, const std::string& extension) {
        if (filename.length() >= extension.length()) {
            return (0 == filename.compare(filename.length() - extension.length(), extension.length(), extension));
        } else {
            return false;
        }
    }
};

template<class T>
class SimpleMathematicsHelper {
public:
    using Data1D = std::vector<T>;
    using Data2D = std::vector<std::vector<T>>;
    using Data3D = std::vector<std::vector<std::vector<T>>>;

public:
    static T quantile(const Data1D &data, T q) {
        if (data.empty()) {
            throw std::invalid_argument("Input data is empty.");
        }
        if (q < 0.0 || q > 1.0) {
            throw std::invalid_argument("Quantile value must be between 0 and 1.");
        }

        Data1D sorted_data = data;
        std::sort(sorted_data.begin(), sorted_data.end());

        T pos = q * (sorted_data.size() - 1);
        auto idx = static_cast<size_t>(std::floor(pos));
        T frac = pos - idx;

        if (idx + 1 < sorted_data.size()) {
            return sorted_data[idx] * (1.0 - frac) + sorted_data[idx + 1] * frac;
        } else {
            return sorted_data[idx];
        }
    }

    /**
     * calculate:: "k,bkc...->bc..."
     * @param a 1-dim Tensor with shape = [kernel]
     * @param b 3-dims Tensor with shape = [batch, kernel, count]
     * @return 2-dims Tensor with shape = [batch, count]
     */
    Data2D einsum_contract(const Data1D &a, const Data3D &b) {
        size_t b_dim = b.size();
        size_t k_dim = a.size();
        size_t c_dim = b[0][0].size();

        Data2D result(b_dim, std::vector<float>(c_dim, 0.0f));

        for (size_t i = 0; i < b_dim; ++i) {
            for (size_t j = 0; j < k_dim; ++j) {
                for (size_t k = 0; k < c_dim; ++k) {
                    result[i][k] += a[j] * b[i][j][k];
                }
            }
        }

        return result;
    }
};

class CommonHelper {
public:
    static void print_progress_bar(float progress_) {
        int bar_width_ = 70;
        std::cout << "[";
        int pos = int(bar_width_ * progress_);
        for (int i = 0; i < bar_width_; ++i) {
            if (i < pos) std::cout << "=";
            else if (i == pos) std::cout << ">";
            else std::cout << " ";
        }
        std::cout << "] " << int(progress_ * 100.0) << " %\r";
        std::cout.flush();
    }
};

} // namespace base
} // namespace sd
} // namespace onnx

#endif  // ONNX_SD_CORE_TOOLS_ONCE
